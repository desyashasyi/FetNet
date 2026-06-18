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
     * Core: cross-prodi SKS recap for a set of lecturers in the active period.
     *
     * @param  Collection<int, int>  $teacherIds
     * @return array{programs: array<int, array{id:int, abbrev:string, name:string}>,
     *               rows: array<int, array{teacher_id:int, name:string, code:?string,
     *                                       perProgram: array<int,int>, total:int}>}
     */
    public function forTeacherIds(Collection $teacherIds, ?int $activeSemesterId): array
    {
        $empty = ['programs' => [], 'rows' => []];

        $periodSemesterIds = $this->periodSemesterIds($activeSemesterId);

        if ($periodSemesterIds->isEmpty() || $teacherIds->isEmpty()) {
            return $empty;
        }

        // One row per (activity, teacher): count each activity's subject credit.
        // Team teaching = full credit to each teacher; a subject split into several
        // activities is counted once per activity. distinct on the activity id guards
        // against accidental duplicate teacher pivot rows.
        $raw = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereIn('at.teacher_id', $teacherIds)
            ->whereNull('a.deleted_at')
            ->whereNull('ap.deleted_at')
            ->distinct()
            ->get(['a.id as activity_id', 'at.teacher_id', 'a.program_id', 's.credit']);

        $matrix     = []; // [teacher_id][program_id] => credit sum
        $programIds = [];
        foreach ($raw as $r) {
            $matrix[$r->teacher_id][$r->program_id] =
                ($matrix[$r->teacher_id][$r->program_id] ?? 0) + (int) $r->credit;
            $programIds[$r->program_id] = true;
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
            ->map(fn ($t) => [
                'teacher_id' => $t->id,
                'name'       => $t->name,
                'code'       => $t->code,
                'perProgram' => $matrix[$t->id] ?? [],
                'total'      => array_sum($matrix[$t->id] ?? []),
            ])->values()->toArray();

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
