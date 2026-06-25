<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Teacher;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * Builds the lecturer SKS (credit) workload recap shown on the client and program
 * "workload" pages. Produces a cross-program matrix: for each lecturer, the credits
 * they teach in each program, plus a per-lecturer total, scoped to the active period.
 *
 * The "active period" is every semester system-wide that shares the active semester's
 * parity (odd/even) and academic year_start, so a guest lecturer's load from another
 * program in the same period is counted too. Credit is counted once per activity
 * (team teaching gives full credit to each attached teacher).
 *
 * Entry points: forClient() (lecturers whose home program belongs to the client),
 * forProgram() (everyone actually teaching in one program, guests included), and
 * forTeacherIds() (the shared core). All return:
 *   ['programs' => [{id, abbrev, name}...], 'rows' => [{teacher_id, name, code,
 *     perProgram: [program_id => credit], total}...]].
 */
class LecturerWorkloadReport
{
    /** Recap for a client's lecturers (home program under the client). */
    public function forClient(Client $client, ?int $activeSemesterId): array
    {
        $programIds = Program::where('client_id', $client->id)->pluck('id');
        $teacherIds = Teacher::whereIn('program_id', $programIds)->pluck('id');

        return $this->forTeacherIds($teacherIds, $activeSemesterId);
    }

    /**
     * Recap for everyone teaching in this program during the active period,
     * including lecturers whose home program is elsewhere (guests / cluster).
     */
    public function forProgram(Program $program, ?int $activeSemesterId): array
    {
        $periodSemesterIds = $this->periodSemesterIds($activeSemesterId);

        if ($periodSemesterIds->isEmpty()) {
            return ['programs' => [], 'rows' => []];
        }

        // Teachers attached to any non-deleted activity scheduled in THIS program
        // during the active period, regardless of their home program.
        $teacherIds = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->where('a.program_id', $program->id)
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereNull('a.deleted_at')
            ->whereNull('ap.deleted_at')
            ->distinct()
            ->pluck('at.teacher_id');

        return $this->forTeacherIds($teacherIds, $activeSemesterId);
    }

    /**
     * Core: cross-prodi SKS recap for a set of lecturers in the active period, split by
     * pengampu role. Per activity, the lecturer attached first (smallest pivot id) is
     * Pengampu 1; everyone else on that activity is Pengampu 2. Both roles receive the
     * full subject credit; the two totals are kept separate (the "P1-P2" cells). For each
     * (lecturer, program, role) a detail list of {code, name, classes} backs the hover.
     *
     * @param  Collection<int, int>  $teacherIds
     * @return array{
     *   programs: array<int, array{id:int, abbrev:string, name:string}>,
     *   rows: array<int, array{
     *     teacher_id:int, name:string, code:?string,
     *     perProgram: array<int, array{p1:int, p2:int,
     *       p1Detail: array<int, array{code:?string,name:?string,classes:array<int,string>}>,
     *       p2Detail: array<int, array{code:?string,name:?string,classes:array<int,string>}>}>,
     *     total: array{p1:int, p2:int, p1Detail:array, p2Detail:array}
     *   }>
     * }
     */
    public function forTeacherIds(Collection $teacherIds, ?int $activeSemesterId): array
    {
        $empty = ['programs' => [], 'rows' => []];

        $periodSemesterIds = $this->periodSemesterIds($activeSemesterId);

        if ($periodSemesterIds->isEmpty() || $teacherIds->isEmpty()) {
            return $empty;
        }

        // Every (activity, teacher) pivot row in the active period, ordered so the first
        // teacher of each activity (smallest pivot id) comes first = Pengampu 1. Not
        // filtered by $teacherIds so we can determine P1 even if it's a teacher we don't
        // report on; we filter when accumulating below.
        $raw = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereNull('a.deleted_at')
            ->whereNull('ap.deleted_at')
            ->orderBy('a.id')
            ->orderBy('at.id')
            ->get(['a.id as activity_id', 'at.id as pivot_id', 'at.teacher_id',
                   'a.program_id', 's.credit', 's.code', 's.name']);

        if ($raw->isEmpty()) {
            return $empty;
        }

        // First teacher (smallest pivot id) per activity = Pengampu 1; rows are ordered.
        $firstTeacher = [];
        foreach ($raw as $r) {
            if (! isset($firstTeacher[$r->activity_id])) {
                $firstTeacher[$r->activity_id] = $r->teacher_id;
            }
        }

        // Class (student group) names per activity, for the hover detail.
        $classNames = DB::table('fetnet_activity_student as ast')
            ->join('fetnet_student as st', 'st.id', '=', 'ast.student_id')
            ->whereIn('ast.activity_id', array_keys($firstTeacher))
            ->orderBy('st.name')
            ->get(['ast.activity_id', 'st.name'])
            ->groupBy('activity_id')
            ->map(fn ($g) => $g->pluck('name')->values()->all());

        // Display label (code, falling back to name) for every teacher seen on any activity,
        // and the ordered teacher list per activity — used to surface tandem/team-teaching
        // partners in each subject's hover detail.
        $teacherDisplay = Teacher::whereIn('id', $raw->pluck('teacher_id')->unique()->all())
            ->get(['id', 'name', 'code'])
            ->mapWithKeys(fn ($t) => [$t->id => ($t->code ?: $t->name)]);

        $activityTeacherIds = [];
        foreach ($raw as $r) {
            $activityTeacherIds[$r->activity_id][] = $r->teacher_id;
        }

        $reportSet  = array_flip($teacherIds->all());
        $matrix     = []; // [teacher_id][program_id]['p1'|'p2'] => credit sum
        $details    = []; // [teacher_id][program_id]['p1'|'p2'] => list of {code,name,classes,co}
        $programIds = [];

        foreach ($raw as $r) {
            if (! isset($reportSet[$r->teacher_id])) {
                continue;
            }
            $role = $firstTeacher[$r->activity_id] === $r->teacher_id ? 'p1' : 'p2';
            $pid  = $r->program_id;

            $matrix[$r->teacher_id][$pid][$role] =
                ($matrix[$r->teacher_id][$pid][$role] ?? 0) + (int) $r->credit;

            // Co-lecturers on this activity (team teaching) = everyone but the current one.
            $co = [];
            foreach ($activityTeacherIds[$r->activity_id] ?? [] as $tid) {
                if ($tid !== $r->teacher_id) {
                    $co[] = $teacherDisplay[$tid] ?? ('T' . $tid);
                }
            }

            $details[$r->teacher_id][$pid][$role][] = [
                'code'    => $r->code,
                'name'    => $r->name,
                'classes' => $classNames->get($r->activity_id, []),
                'co'      => $co,
            ];

            $programIds[$pid] = true;
        }

        if (empty($matrix)) {
            return $empty;
        }

        $programs = Program::whereIn('id', array_keys($programIds))
            ->orderBy('abbrev')
            ->get(['id', 'abbrev', 'name'])
            ->map(fn ($p) => [
                'id'     => $p->id,
                'abbrev' => $p->abbrev ?? '?',
                'name'   => $p->name ?? '',
            ])->values()->toArray();

        $rows = Teacher::whereIn('id', array_keys($matrix))
            ->orderBy('name')
            ->get(['id', 'name', 'code'])
            ->map(function ($t) use ($matrix, $details) {
                $perProgram = [];
                $tp1 = 0; $tp2 = 0; $tp1d = []; $tp2d = [];

                foreach ($matrix[$t->id] as $pid => $byRole) {
                    $p1 = $byRole['p1'] ?? 0;
                    $p2 = $byRole['p2'] ?? 0;
                    $p1d = $details[$t->id][$pid]['p1'] ?? [];
                    $p2d = $details[$t->id][$pid]['p2'] ?? [];

                    $perProgram[$pid] = [
                        'p1'       => $p1,
                        'p2'       => $p2,
                        'p1Detail' => $p1d,
                        'p2Detail' => $p2d,
                    ];

                    $tp1  += $p1;
                    $tp2  += $p2;
                    $tp1d = array_merge($tp1d, $p1d);
                    $tp2d = array_merge($tp2d, $p2d);
                }

                return [
                    'teacher_id' => $t->id,
                    'name'       => $t->name,
                    'code'       => $t->code,
                    'perProgram' => $perProgram,
                    'total'      => ['p1' => $tp1, 'p2' => $tp2, 'p1Detail' => $tp1d, 'p2Detail' => $tp2d],
                ];
            })->values()->toArray();

        return ['programs' => $programs, 'rows' => $rows];
    }

    /**
     * Semester ids system-wide matching the active period (same year_start + parity).
     *
     * @return Collection<int, int>
     */
    private function periodSemesterIds(?int $activeSemesterId): Collection
    {
        $active = $activeSemesterId
            ? Semester::with('academicYear')->find($activeSemesterId)
            : null;

        if (! $active || ! $active->academicYear) {
            return collect();
        }

        return Semester::where('semester', $active->semester)
            ->whereHas('academicYear', fn ($q) => $q->where('year_start', $active->academicYear->year_start))
            ->pluck('id');
    }
}
