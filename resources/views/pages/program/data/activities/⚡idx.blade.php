<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Activity;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

/**
 * Activities page for the signed-in program. Two views: "By Subject" (subjects with
 * their activities as inline class badges) and "All" (flat activity table), both scoped
 * to the chosen academic year + semester (HasProgramSemester trait). Supports add/edit
 * (sheet), split into sub-activities, toggle active, delete, and the subject-planning
 * modal. Hosts the activity-edit, split, tag-manager, and planning child components.
 */
new #[Layout('layouts.program')] class extends Component
{
    use WithPagination, Toast, HasProgramSemester;

    public string $search         = '';
    public string $view           = 'subject';
    public bool   $delModal       = false;
    public ?int   $deleteId       = null;
    public ?int   $teacherFilterId = null;
    public ?int   $studentFilterId = null;

    /** Filter by the subject's curriculum semester (1–8), independent of the academic period. */
    public ?int   $subjectSemester = null;

    public array $headers = [
        ['key' => 'semester', 'label' => 'Sem',     'class' => 'w-1/12 text-center align-top'],
        ['key' => 'code',     'label' => 'Code',    'class' => 'w-1/12 align-top'],
        ['key' => 'name',     'label' => 'Subject', 'class' => 'w-3/12 align-top'],
        ['key' => 'classes',  'label' => 'Classes', 'class' => 'w-7/12 align-top'],
    ];

    /** The signed-in user's program; scopes every query on this page. */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Seed the academic-year/semester context for the program's client. */
    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    /** Search / view / teacher-filter changes reset pagination. */
    public function updatedSearch(): void         { $this->resetPage(); }
    public function updatedView(): void           { $this->resetPage(); }
    public function updatedSubjectSemester(): void { $this->resetPage(); }
    public function updatedTeacherFilterId(): void { $this->resetPage(); }
    public function updatedStudentFilterId(): void { $this->resetPage(); }

    /** Persist the chosen semester and reset pagination. */
    public function updatedSemesterId(): void
    {
        $this->persistSemester();
        $this->resetPage();
    }

    /** Changing academic year clears the semester, reloads options, persists, resets page. */
    public function updatedAcademicYearId(): void
    {
        $this->semesterId = null;
        $this->loadProgramSemesters();
        $this->persistSemester();
        $this->resetPage();
    }


    /** Open the delete confirmation for one activity. */
    public function confirmDelete(int $id): void
    {
        $this->deleteId = $id;
        $this->delModal = true;
    }

    /** Delete the confirmed activity (its teacher/student assignments detach). */
    public function delete(): void
    {
        Activity::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        $this->warning('Activity deleted.', position: 'toast-top toast-center');
    }

    /** Flip an activity's active flag (the dot toggle in the By-Subject view). */
    public function toggleActive(int $id): void
    {
        $activity = Activity::findOrFail($id);
        $activity->update(['active' => ! $activity->active]);
    }

    /** Re-render after a child sheet saves an activity or planning changes. */
    #[On('activity-changed')]
    #[On('planning-changed')]
    public function refreshFromChild(): void
    {
        // empty: triggers re-render after child save
    }

    /**
     * View data for both modes: $subjects (paginated subjects with their semester-scoped
     * activities eager-loaded, for the By-Subject view) and $activities (flat paginated
     * activities decorated with display labels, for the All view), plus the program id.
     */
    public function with(): array
    {
        $program = $this->program();

        $subjectQuery = Subject::with(['activities' => fn($q) => $q
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) =>
                    $p->where('semester_id', $this->semesterId)))
                ->when($this->teacherFilterId, fn($q) => $q->whereHas('teachers',
                    fn($t) => $t->where('fetnet_teacher.id', $this->teacherFilterId)))
                ->when($this->studentFilterId, fn($q) => $q->whereHas('students',
                    fn($t) => $t->where('fetnet_student.id', $this->studentFilterId)))
                ->with(['teachers', 'type', 'students', 'subActivities'])
              ])
                ->when($program, fn($q) => $q->where('program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('activityPlannings', fn($p) =>
                    $p->where('semester_id', $this->semesterId)->where('program_id', $program?->id)))
                ->when($this->search, fn($q) => $q
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('code', 'like', "%{$this->search}%"))
                ->when($this->subjectSemester, fn($q) => $q->where('semester', $this->subjectSemester))
                ->when($this->teacherFilterId, fn($q) => $q->whereHas('activities',
                    fn($a) => $a->whereHas('teachers',
                        fn($t) => $t->where('fetnet_teacher.id', $this->teacherFilterId))
                    ->when($this->semesterId, fn($a) => $a->whereHas('planning',
                        fn($p) => $p->where('semester_id', $this->semesterId)))))
                ->when($this->studentFilterId, fn($q) => $q->whereHas('activities',
                    fn($a) => $a->whereHas('students',
                        fn($t) => $t->where('fetnet_student.id', $this->studentFilterId))
                    ->when($this->semesterId, fn($a) => $a->whereHas('planning',
                        fn($p) => $p->where('semester_id', $this->semesterId)))))
                ->orderBy('semester')->orderBy('code');

        $subjects = $subjectQuery->paginate(6);

        $activityQuery = Activity::query()
                ->select('fetnet_activity.*')
                ->with(['planning.subject', 'type', 'teachers', 'students'])
                // Join the plan + subject so the All view sorts by semester then subject code
                // (matching the By-Subject view) instead of by activity id.
                ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'fetnet_activity.planning_id')
                ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
                ->when($program && $this->view === 'all', fn($q) => $q->where('fetnet_activity.program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) => $p->where('semester_id', $this->semesterId)))
                ->when($this->search, fn($q) => $q->whereHas('planning', fn($p) => $p->whereHas('subject',
                    fn($s) => $s->where('name', 'like', "%{$this->search}%")
                                ->orWhere('code', 'like', "%{$this->search}%"))))
                ->when($this->subjectSemester, fn($q) => $q->where('s.semester', $this->subjectSemester))
                ->when($this->teacherFilterId, fn($q) => $q->whereHas('teachers',
                    fn($t) => $t->where('fetnet_teacher.id', $this->teacherFilterId)))
                ->when($this->studentFilterId, fn($q) => $q->whereHas('students',
                    fn($t) => $t->where('fetnet_student.id', $this->studentFilterId)))
                ->orderBy('s.semester')->orderBy('s.code')->orderBy('fetnet_activity.id');

        $activities = $activityQuery->paginate(6)
                ->through(fn($a) => tap($a, fn($item) => [
                    $item->subject_nm  = $a->planning?->subject?->code . ' — ' . $a->planning?->subject?->name,
                    $item->type_nm     = $a->type?->name ?? '-',
                    $item->teachers_nm = $a->teachers->pluck('code')->filter()->implode(', ') ?: '-',
                    $item->students_nm = $a->students->pluck('name')->implode(', ') ?: '-',
                ]));

        // Total SKS across the full filtered set (all pages), matching the active view:
        // By-Subject sums each subject's credit once; All sums each activity's subject credit.
        $totalSks = $this->view === 'subject'
            ? (int) (clone $subjectQuery)->sum('credit')
            : (int) (clone $activityQuery)->sum('s.credit');

        // Distinct curriculum semesters present in this program's subjects (1–8).
        $subjectSemesterOptions = $program
            ? Subject::where('program_id', $program->id)
                ->whereNotNull('semester')
                ->distinct()->orderBy('semester')->pluck('semester')
                ->map(fn($s) => ['id' => $s, 'name' => "Semester {$s}"])->values()->toArray()
            : [];

        // Teachers who have at least one activity in this program (optionally scoped to semester).
        $teacherOptions = $program
            ? Teacher::whereHas('activities', fn($q) => $q
                ->where('fetnet_activity.program_id', $program->id)
                ->when($this->semesterId, fn($q) => $q->whereHas('planning',
                    fn($p) => $p->where('semester_id', $this->semesterId))))
                ->orderBy('name')
                ->get(['id', 'name', 'code'])
                ->map(fn($t) => ['id' => $t->id, 'name' => $t->code ? "{$t->code} — {$t->name}" : $t->name])
                ->values()->toArray()
            : [];

        // Student groups that appear in at least one activity in this program/semester.
        $studentOptions = $program
            ? Student::whereHas('activities', fn($q) => $q
                ->where('fetnet_activity.program_id', $program->id)
                ->when($this->semesterId, fn($q) => $q->whereHas('planning',
                    fn($p) => $p->where('semester_id', $this->semesterId))))
                ->orderBy('name')
                ->get(['id', 'name'])
                ->map(fn($s) => ['id' => $s->id, 'name' => $s->name])
                ->values()->toArray()
            : [];

        return [
            'subjects'                => $subjects,
            'activities'              => $activities,
            'totalSks'                => $totalSks,
            'programId'               => $program?->id,
            'subjectSemesterOptions'  => $subjectSemesterOptions,
            'teacherOptions'          => $teacherOptions,
            'studentOptions'          => $studentOptions,
        ];
    }
}; ?>

<div>
    <x-header title="Activities" subtitle="Manage course sessions & assignments" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                      placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions"
                      placeholder="Semester" class="w-48" />
        @endif
        @if(count($subjectSemesterOptions))
            <x-select wire:model.live="subjectSemester" :options="$subjectSemesterOptions"
                      placeholder="All Course Semesters" class="w-52" />
        @endif
        @if(count($teacherOptions))
            <x-choices single clearable searchable
                       wire:model.live="teacherFilterId"
                       :options="$teacherOptions"
                       placeholder="All lecturers"
                       class="w-max min-w-48" />
        @endif
        @if(count($studentOptions))
            <x-choices single clearable searchable
                       wire:model.live="studentFilterId"
                       :options="$studentOptions"
                       placeholder="All student groups"
                       class="w-max min-w-48" />
        @endif
        <x-input placeholder="Search subject..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <div class="join">
            <x-button label="By Subject" class="btn-sm join-item {{ $view === 'subject' ? 'btn-primary' : 'btn-ghost' }}"
                      wire:click="$set('view','subject')" />
            <x-button label="All"        class="btn-sm join-item {{ $view === 'all'     ? 'btn-primary' : 'btn-ghost' }}"
                      wire:click="$set('view','all')" />
        </div>
        @if($semesterId)
            <x-button label="Planning" icon="o-calendar-days" class="btn-ghost btn-sm" wire:click="$dispatch('open-planning')" />
        @endif
    </div>

    @if($view === 'subject')
    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$subjects" with-pagination container-class="overflow-hidden" class="table-fixed">

            @scope('cell_semester', $row)
                <div class="text-center">{{ $row->semester ?? '-' }}</div>
            @endscope

            @scope('cell_classes', $row)
                <div class="flex flex-wrap gap-y-1 gap-x-2">
                    @forelse($row->activities as $activity)
                        @php
                            $teachers   = $activity->teachers->pluck('code')->filter()->implode('|');
                            $groups     = $activity->students->pluck('name')->implode('|');
                            $tooltip    = $activity->type?->name ?? '';
                            $active     = $activity->active;
                            $subs       = $activity->subActivities;
                            $durationStr = $subs->count() > 1
                                ? $subs->pluck('duration')->implode('+')
                                : (string) $activity->duration;
                        @endphp
                        <div class="flex flex-col items-start gap-0 {{ $active ? '' : 'opacity-50' }}">
                            <div class="flex items-center gap-1">
                                <div class="tooltip tooltip-top" data-tip="{{ $tooltip }}">
                                    <x-badge value="{{ ($teachers ?: '?') . ($groups ? ' ('.$groups.')' : ' (no student)') . ' ' . $durationStr }}"
                                             class="{{ $active ? 'badge-primary badge-dash' : 'badge-dash !bg-base-200 !text-base-content/40 !border-base-content/20' }} {{ !$groups ? 'border-warning text-warning' : '' }}" />
                                </div>
                            </div>
                            <div class="flex items-center">
                                <button wire:click="toggleActive({{ $activity->id }})"
                                        class="btn btn-ghost btn-xs btn-square {{ $active ? 'text-success' : 'text-base-content/30' }}"
                                        title="{{ $active ? 'Active — click to deactivate' : 'Inactive — click to activate' }}">
                                    <x-icon name="{{ $active ? 'o-check-circle' : 'o-x-circle' }}" class="w-3 h-3" />
                                </button>
                                <button wire:click="$dispatch('open-activity-edit', { id: {{ $activity->id }} })"
                                        class="btn btn-ghost btn-xs btn-square" title="Edit">
                                    <x-icon name="o-pencil" class="w-3 h-3" />
                                </button>
                                <button wire:click="$dispatch('open-activity-split', { id: {{ $activity->id }} })"
                                        class="btn btn-ghost btn-xs btn-square" title="Split">
                                    <x-icon name="o-scissors" class="w-3 h-3" />
                                </button>
                                <button wire:click="confirmDelete({{ $activity->id }})"
                                        class="btn btn-ghost btn-xs btn-square text-error" title="Delete">
                                    <x-icon name="o-trash" class="w-3 h-3" />
                                </button>
                            </div>
                        </div>
                    @empty
                        <span class="text-base-content/30 text-xs italic">no activities</span>
                    @endforelse
                </div>
            @endscope


        </x-table>
    </x-card>
    @else
    <x-card>
        <div class="overflow-x-auto">
            <table class="table table-sm w-full table-fixed">
                <thead>
                    <tr class="text-base-content/60 text-xs uppercase bg-base-200">
                        <th class="w-5/12">Subject</th>
                        <th class="w-1/12">Type</th>
                        <th class="w-1/12 text-center">Duration</th>
                        <th class="w-2/12">Lecturers</th>
                        <th class="w-2/12">Groups</th>
                        <th class="w-1/12"></th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($activities as $row)
                        <tr class="{{ $row->active ? '' : 'opacity-50' }} border-b border-base-200 hover:bg-base-200/40">
                            <td class="text-sm py-2">{{ $row->subject_nm }}</td>
                            <td class="text-sm py-2">{{ $row->type_nm }}</td>
                            <td class="text-sm py-2 text-center">{{ $row->duration }} hr</td>
                            <td class="text-sm py-2">{{ $row->teachers_nm }}</td>
                            <td class="text-sm py-2">{{ $row->students_nm }}</td>
                            <td class="py-2">
                                <div class="flex justify-end gap-1">
                                    <button wire:click="toggleActive({{ $row->id }})"
                                            class="btn btn-ghost btn-sm btn-square {{ $row->active ? 'text-success' : 'text-base-content/30' }}"
                                            title="{{ $row->active ? 'Active — click to deactivate' : 'Inactive — click to activate' }}">
                                        <x-icon name="{{ $row->active ? 'o-check-circle' : 'o-x-circle' }}" class="w-4 h-4" />
                                    </button>
                                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                                              wire:click="$dispatch('open-activity-edit', { id: {{ $row->id }} })" tooltip="Edit" />
                                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error"
                                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-8 text-base-content/40 text-sm italic">No activities found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        <div class="mt-3">
            {{ $activities->links() }}
        </div>
    </x-card>
    @endif

    {{-- Total SKS across the whole filtered set (all pages), for the active view. --}}
    <div class="flex justify-end items-center gap-2 mt-3">
        <span class="text-sm text-base-content/60">Total SKS</span>
        <x-badge value="{{ $totalSks }}" class="badge-primary badge-lg" />
    </div>

    <x-modal wire:model="delModal" title="Delete Activity" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this activity? Teacher and student assignments will also be removed.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>

    <livewire:pages::program.data.activities.activity-edit-sheet
        :program-id="$programId"
        :semester-id="$semesterId" />

    <livewire:pages::program.data.activities.split-sheet />

    <livewire:pages::program.data.activities.tag-manager-sheet
        :program-id="$programId" />

    <livewire:pages::program.data.activities.planning-sheet
        :program-id="$programId"
        :semester-id="$semesterId" />
</div>
