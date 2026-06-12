<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\Space;
use App\Models\FetNet\StudentTimeConstraint;
use App\Models\FetNet\TeacherTimeConstraint;
use Illuminate\Support\Facades\Storage;

/**
 * Read the auxiliary report files FET writes alongside the timetable
 * (errors, warnings, placed activities, open log). All paths are
 * relative to Storage::disk('local').
 *
 * Source-of-truth lives on disk; nothing is persisted in DB except the
 * paths already on FetCompile.
 */
class FetReportReader
{
    /**
     * @return array{
     *   issues: list<array{emit_id:?int, activity_id:?int, message:string, subject:?string, teacher:?string, students:?string}>,
     *   warnings: list<string>,
     *   placed_count: int,
     *   placed: list<array{emit_id:int, activity_id:?int, subject:?string, teacher:?string, students:?string}>,
     *   unplaced: list<array{emit_id:int, activity_id:?int, subject:?string, teacher:?string, students:?string}>,
     *   summary: array<string, string>,
     *   result: string,
     * }
     */
    public function read(string $solverOutputDir, int $clientId, int $semesterId, ?string $resultFetPath = null): array
    {
        $disk = Storage::disk('local');

        $errorsPath   = "{$solverOutputDir}/logs/errors.txt";
        $warningsPath = "{$solverOutputDir}/logs/warnings.txt";
        $placedPath   = "{$solverOutputDir}/logs/max_placed_activities.txt";
        $openLogPath  = "{$solverOutputDir}/logs/file_open.log";
        $resultPath   = "{$solverOutputDir}/logs/result.txt";

        $issues       = $this->parseIssues($disk->exists($errorsPath)   ? $disk->get($errorsPath)   : '');
        $warnings     = $this->parseWarnings($disk->exists($warningsPath) ? $disk->get($warningsPath) : '');
        $placedCount  = $this->parsePlacedCount($disk->exists($placedPath) ? $disk->get($placedPath) : '');
        $summary      = $this->parseSummary($disk->exists($openLogPath)  ? $disk->get($openLogPath)  : '');
        $result       = $disk->exists($resultPath) ? trim($disk->get($resultPath)) : '';

        $placedEmitIds = [];
        if ($resultFetPath) {
            // Solution lives in the *_activities.xml sibling of the *.fet file.
            $solutionPath = preg_replace('/_data_and_timetable\.fet$/', '_activities.xml', $resultFetPath);
            if ($solutionPath && $disk->exists($solutionPath)) {
                $placedEmitIds = $this->parsePlacedIdsFromResult($disk->get($solutionPath));
            }
        }

        $reverse = $this->loadReverseMap($clientId, $semesterId);

        $allEmitIds = array_keys($reverse);
        $unplacedEmitIds = $placedEmitIds
            ? array_values(array_diff($allEmitIds, $placedEmitIds))
            : $allEmitIds; // before/no result: everything is still "unplaced"

        $placed   = $this->resolveEmitIds($placedEmitIds,   $reverse);
        $unplaced = $this->resolveEmitIds($unplacedEmitIds, $reverse);
        $this->diagnoseUnplaced($unplaced, $reverse, $clientId, $semesterId);

        $this->enrichIssues($issues, $reverse);

        return [
            'issues'       => $issues,
            'warnings'     => $warnings,
            'placed_count' => $placedCount,
            'placed'       => $placed,
            'unplaced'     => $unplaced,
            'summary'      => $summary,
            'result'       => $result,
        ];
    }

    private function resolveEmitIds(array $emitIds, array $reverse): array
    {
        if (empty($emitIds)) return [];
        $dbIds = [];
        foreach ($emitIds as $eid) {
            if (isset($reverse[$eid])) $dbIds[] = $reverse[$eid];
        }
        $activities = empty($dbIds) ? collect() : Activity::whereIn('id', array_unique($dbIds))
            ->with([
                'planning.subject:id,code,name',
                'teachers:id,code,name',
                'students:id,name,number_of_student',
                'spaces:id,code,name,capacity',
            ])
            ->get()
            ->keyBy('id');

        $out = [];
        foreach ($emitIds as $eid) {
            $dbId = $reverse[$eid] ?? null;
            $a    = $dbId ? $activities->get($dbId) : null;
            $out[] = [
                'emit_id'     => (int) $eid,
                'activity_id' => $a?->id,
                'subject'     => $a?->planning?->subject?->code ?? $a?->planning?->subject?->name,
                'teacher'     => $a
                    ? ($a->teachers->pluck('code')->filter()->implode(', ')
                        ?: $a->teachers->pluck('name')->implode(', '))
                    : null,
                'students'    => $a?->students->pluck('name')->implode(', '),
                'reason'      => null,
                '_activity'   => $a,
            ];
        }
        return $out;
    }

    /**
     * Try to explain why FET couldn't place each unplaced activity. Heuristics
     * derived from the most common failure modes:
     *   - Total students > max room capacity in the client
     *   - Teacher overcommitted (sum of all activity durations > available slots)
     *   - Activity has no eligible room (capacity-wise) at all
     *   - Otherwise: "Schedule conflict (teacher/student/room overlap)"
     */
    private function diagnoseUnplaced(array &$unplaced, array $reverse, int $clientId, int $semesterId): void
    {
        if (empty($unplaced)) return;

        $maxRoomCap   = (int) Space::where('client_id', $clientId)->max('capacity');
        [$daysCount, $hoursPerDay] = $this->daysAndHours($clientId);
        $slotsPerWeek = $daysCount * $hoursPerDay;

        $plannings = ActivityPlanning::whereIn('program_id',
                        \App\Models\FetNet\Program::where('client_id', $clientId)->pluck('id'))
                    ->where('semester_id', $semesterId)
                    ->pluck('id');

        // Pre-compute teacher and student load + unavailability so each
        // activity diagnosis runs in O(1) lookups.
        $teacherLoad = []; // teacher_id => total hours
        $allActs = Activity::whereIn('planning_id', $plannings)
                    ->with(['teachers:id', 'students:id', 'subActivities'])
                    ->get();
        $studentLoad = []; // student_id => total hours
        foreach ($allActs as $a) {
            $dur = (int) ($a->duration ?? 0);
            if ($a->subActivities->count() > 1) {
                $dur = (int) $a->subActivities->sum('duration');
            }
            foreach ($a->teachers as $t) $teacherLoad[$t->id] = ($teacherLoad[$t->id] ?? 0) + $dur;
            foreach ($a->students as $s) $studentLoad[$s->id] = ($studentLoad[$s->id] ?? 0) + $dur;
        }

        $teacherIds = $allActs->flatMap(fn($a) => $a->teachers->pluck('id'))->unique()->all();
        $studentIds = $allActs->flatMap(fn($a) => $a->students->pluck('id'))->unique()->all();

        $teacherUnavail = TeacherTimeConstraint::whereIn('teacher_id', $teacherIds)
            ->selectRaw('teacher_id, COUNT(*) AS c')->groupBy('teacher_id')
            ->pluck('c', 'teacher_id')->toArray();
        $studentUnavail = StudentTimeConstraint::whereIn('student_id', $studentIds)
            ->selectRaw('student_id, COUNT(*) AS c')->groupBy('student_id')
            ->pluck('c', 'student_id')->toArray();

        foreach ($unplaced as &$u) {
            $a = $u['_activity'] ?? null;
            if (! $a) { $u['reason'] = 'Could not resolve activity from FET id.'; continue; }

            $reasons   = [];
            $students  = (int) $a->students->sum('number_of_student');
            $duration  = (int) ($a->duration ?? 0);
            if ($a->subActivities && $a->subActivities->count() > 1) {
                $duration = (int) $a->subActivities->max('duration');
            }

            // 1. Room capacity
            if ($students > 0 && $maxRoomCap > 0 && $students > $maxRoomCap) {
                $reasons[] = "Students ({$students}) exceed largest room capacity ({$maxRoomCap}).";
            } elseif ($students > 0 && $a->spaces->isNotEmpty()) {
                $eligible = $a->spaces->filter(fn($r) => (int) ($r->capacity ?? 0) >= $students);
                if ($eligible->isEmpty()) {
                    $caps = $a->spaces->pluck('capacity')->implode(', ');
                    $reasons[] = "No preferred room fits {$students} students (preferred caps: {$caps}).";
                }
            }

            // 2. Duration > slots per day
            if ($hoursPerDay > 0 && $duration > $hoursPerDay) {
                $reasons[] = "Duration {$duration} hrs exceeds {$hoursPerDay} slots per day.";
            }

            // 3. Teacher load + unavailability
            foreach ($a->teachers as $t) {
                $load    = $teacherLoad[$t->id] ?? 0;
                $blocked = $teacherUnavail[$t->id] ?? 0;
                $code    = $t->code ?? "T{$t->id}";
                if ($slotsPerWeek > 0 && ($load + $blocked) > $slotsPerWeek) {
                    $reasons[] = "Teacher {$code} tight: {$load} hrs scheduled + {$blocked} blocked / {$slotsPerWeek} slots/wk.";
                    break;
                }
                if ($slotsPerWeek > 0 && $load > $slotsPerWeek) {
                    $reasons[] = "Teacher {$code} overcommitted ({$load} hrs, {$slotsPerWeek} slots/wk).";
                    break;
                }
            }

            // 4. Student set load + unavailability
            foreach ($a->students as $st) {
                $load    = $studentLoad[$st->id] ?? 0;
                $blocked = $studentUnavail[$st->id] ?? 0;
                if ($slotsPerWeek > 0 && ($load + $blocked) > $slotsPerWeek) {
                    $reasons[] = "Student set {$st->name} tight: {$load} hrs + {$blocked} blocked / {$slotsPerWeek} slots/wk.";
                    break;
                }
            }

            if (empty($reasons)) {
                $reasons[] = 'Schedule conflict: no compatible slot found. Likely an overlap with another activity sharing teacher or student set, or activity-specific time constraints. FET runtime does not report per-activity cause.';
            }

            $u['reason'] = implode(' ', $reasons);
        }

        foreach ($unplaced as &$u) { unset($u['_activity']); }
    }

    /** @return array{0:int,1:int}  [daysCount, hoursPerDay] */
    private function daysAndHours(int $clientId): array
    {
        $config = ClientConfig::where('client_id', $clientId)->first();
        if (! $config) return [0, 0];
        $days  = count($config->dayLabels() ?: []);
        $slots = $config->generateSlots() ?: [];
        $hours = count(array_filter($slots, fn($s) => ! ($s['break'] ?? false)));
        return [$days, $hours];
    }

    private function loadReverseMap(int $clientId, int $semesterId): array
    {
        $disk = Storage::disk('local');
        $mapPath = "fet/{$clientId}/sem{$semesterId}.map.json";
        if (! $disk->exists($mapPath)) return [];
        $map = json_decode($disk->get($mapPath), true) ?: [];
        $reverse = [];
        foreach ($map as $dbId => $emitIds) {
            foreach ((array) $emitIds as $emit) {
                $reverse[(int) $emit] = (int) $dbId;
            }
        }
        return $reverse;
    }

    /**
     * errors.txt is a sequence of blocks like:
     *   Title: ...
     *   Message: ...
     *   Button 0 text: ...
     *   ...
     * separated by blank lines.
     */
    private function parseIssues(string $content): array
    {
        if (trim($content) === '') return [];
        $content = preg_replace("/^\xEF\xBB\xBF/", '', $content);
        $blocks  = preg_split("/\R{2,}/", trim($content));
        $issues  = [];
        foreach ($blocks as $block) {
            if (! preg_match('/^Message:\s*(.+)$/m', $block, $m)) continue;
            $message = trim($m[1]);
            $emitId = null;
            if (preg_match('/activity with id=(\d+)/i', $message, $am)) {
                $emitId = (int) $am[1];
            }
            $issues[] = [
                'emit_id'     => $emitId,
                'activity_id' => null,
                'message'     => $message,
                'subject'     => null,
                'teacher'     => null,
                'students'    => null,
            ];
        }
        return $issues;
    }

    private function parseWarnings(string $content): array
    {
        if (trim($content) === '') return [];
        $content = preg_replace("/^\xEF\xBB\xBF/", '', $content);
        // Each warning's "Message:" block, take just the message body.
        $blocks = preg_split("/\R{2,}/", trim($content));
        $out = [];
        foreach ($blocks as $block) {
            if (preg_match('/^Message:\s*(.+)$/m', $block, $m)) {
                $out[] = trim($m[1]);
            }
        }
        return $out;
    }

    /**
     * Highest "FET reached N activities placed" value from the chronological
     * placement log. During a long run this grows over time; while solver is
     * still in precompute it returns 0.
     */
    private function parsePlacedCount(string $content): int
    {
        if (trim($content) === '') return 0;
        $content = preg_replace("/^\xEF\xBB\xBF/", '', $content);
        $max = 0;
        foreach (preg_split('/\R/', $content) ?: [] as $line) {
            if (preg_match('/reached\s+(\d+)\s+activities placed/i', $line, $m)) {
                $n = (int) $m[1];
                if ($n > $max) $max = $n;
            }
        }
        return $max;
    }

    /**
     * Authoritative solution is in *_activities.xml (sibling of the result
     * .fet file). Each <Activity> has Id/Day/Hour/Room — Day/Hour non-empty
     * means FET placed it in time. Empty Room means partially placed.
     */
    private function parsePlacedIdsFromResult(string $xmlContent): array
    {
        $xml = @simplexml_load_string($xmlContent);
        if (! $xml) return [];
        $ids = [];
        foreach (($xml->Activity ?? []) as $a) {
            $day  = trim((string) $a->Day);
            $hour = trim((string) $a->Hour);
            if ($day === '' || $hour === '') continue;
            $ids[] = (int) $a->Id;
        }
        return array_values(array_unique($ids));
    }

    private function parseSummary(string $content): array
    {
        if (trim($content) === '') return [];
        $content = preg_replace("/^\xEF\xBB\xBF/", '', $content);
        $out = [];
        foreach (preg_split('/\R/', $content) ?: [] as $line) {
            if (preg_match('/^Added\s+(\d+)\s+(.+)$/i', trim($line), $m)) {
                $out[trim($m[2])] = $m[1];
            }
        }
        return $out;
    }

    private function enrichIssues(array &$issues, array $reverse): void
    {
        $dbIds = [];
        foreach ($issues as $i) {
            if ($i['emit_id'] !== null && isset($reverse[$i['emit_id']])) {
                $dbIds[] = $reverse[$i['emit_id']];
            }
        }
        if (empty($dbIds)) return;

        $activities = Activity::whereIn('id', array_unique($dbIds))
            ->with([
                'planning.subject:id,code,name',
                'teachers:id,code,name',
                'students:id,name',
            ])
            ->get()
            ->keyBy('id');

        foreach ($issues as &$issue) {
            if ($issue['emit_id'] === null) continue;
            $dbId = $reverse[$issue['emit_id']] ?? null;
            if (! $dbId) continue;
            $a = $activities->get($dbId);
            if (! $a) continue;
            $issue['activity_id'] = $a->id;
            $issue['subject']     = $a->planning?->subject?->code
                                 ?? $a->planning?->subject?->name;
            $issue['teacher']     = $a->teachers->pluck('code')->filter()->implode(', ')
                                 ?: $a->teachers->pluck('name')->implode(', ');
            $issue['students']    = $a->students->pluck('name')->implode(', ');
        }
    }
}
