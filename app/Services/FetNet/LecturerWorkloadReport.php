<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Teacher;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class LecturerWorkloadReport
{
    /** Recap for a client's lecturers (home program under the client). */
    public function forClient(Client $client, ?int $activeSemesterId): array
    {
        $programIds = Program::where('client_id', $client->id)->pluck('id');
        $teacherIds = Teacher::whereIn('program_id', $programIds)->pluck('id');

        return $this->forTeacherIds($teacherIds, $activeSemesterId);
    }

    /** Recap for a single program's lecturers (home program = this program). */
    public function forProgram(Program $program, ?int $activeSemesterId): array
    {
        $teacherIds = Teacher::where('program_id', $program->id)->pluck('id');

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

        $active = $activeSemesterId
            ? Semester::with('academicYear')->find($activeSemesterId)
            : null;

        if (! $active || ! $active->academicYear) {
            return $empty;
        }

        // All semesters system-wide matching the active period (same year_start + parity).
        $periodSemesterIds = Semester::where('semester', $active->semester)
            ->whereHas('academicYear', fn ($q) => $q->where('year_start', $active->academicYear->year_start))
            ->pluck('id');

        if ($periodSemesterIds->isEmpty() || $teacherIds->isEmpty()) {
            return $empty;
        }

        // distinct (teacher, prodi, subject, credit) => "per subject once"; team teaching = full credit each.
        $raw = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereIn('at.teacher_id', $teacherIds)
            ->whereNull('a.deleted_at')
            ->whereNull('ap.deleted_at')
            ->distinct()
            ->get(['at.teacher_id', 'a.program_id', 'ap.subject_id', 's.credit']);

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
}
