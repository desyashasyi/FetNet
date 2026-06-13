<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Activity;
use App\Models\FetNet\Program;
use App\Models\FetNet\Subject;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.program')] class extends Component
{
    use WithPagination, Toast, HasProgramSemester;

    public string $search   = '';
    public string $view     = 'subject';
    public bool   $delModal = false;
    public ?int   $deleteId = null;

    public array $headers = [
        ['key' => 'semester', 'label' => 'Sem',      'class' => 'w-1/12 text-center align-top'],
        ['key' => 'code',     'label' => 'Code',     'class' => 'w-1/12 align-top'],
        ['key' => 'name',     'label' => 'Subject',  'class' => 'w-4/12 align-top'],
        ['key' => 'classes',  'label' => 'Classes',  'class' => 'w-5/12 align-top'],
        ['key' => 'action',   'label' => '',         'class' => 'w-1/12 align-top text-right'],
    ];

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    public function updatedSearch(): void { $this->resetPage(); }
    public function updatedView(): void  { $this->resetPage(); }

    public function updatedSemesterId(): void
    {
        $this->persistSemester();
        $this->resetPage();
    }

    public function updatedAcademicYearId(): void
    {
        $this->semesterId = null;
        $this->loadProgramSemesters();
        $this->persistSemester();
        $this->resetPage();
    }


    public function confirmDelete(int $id): void
    {
        $this->deleteId = $id;
        $this->delModal = true;
    }

    public function delete(): void
    {
        Activity::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        $this->warning('Activity deleted.', position: 'toast-top toast-center');
    }

    public function toggleActive(int $id): void
    {
        $activity = Activity::findOrFail($id);
        $activity->update(['active' => ! $activity->active]);
    }

    #[On('activity-changed')]
    #[On('planning-changed')]
    public function refreshFromChild(): void
    {
        // empty: triggers re-render after child save
    }

    public function with(): array
    {
        $program = $this->program();

        $subjects = Subject::with(['activities' => fn($q) => $q
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) =>
                    $p->where('semester_id', $this->semesterId)))
                ->with(['teachers', 'type', 'students', 'subActivities'])
              ])
                ->when($program, fn($q) => $q->where('program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('activityPlannings', fn($p) =>
                    $p->where('semester_id', $this->semesterId)->where('program_id', $program?->id)))
                ->when($this->search, fn($q) => $q
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('code', 'like', "%{$this->search}%"))
                ->orderBy('semester')->orderBy('code')
                ->paginate(6);

        $activities = Activity::with(['planning.subject', 'type', 'teachers', 'students'])
                ->when($program && $this->view === 'all', fn($q) => $q->where('program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) => $p->where('semester_id', $this->semesterId)))
                ->when($this->search, fn($q) => $q->whereHas('planning', fn($p) => $p->whereHas('subject',
                    fn($s) => $s->where('name', 'like', "%{$this->search}%")
                                ->orWhere('code', 'like', "%{$this->search}%"))))
                ->paginate(6)
                ->through(fn($a) => tap($a, fn($item) => [
                    $item->subject_nm  = $a->planning?->subject?->code . ' — ' . $a->planning?->subject?->name,
                    $item->type_nm     = $a->type?->name ?? '-',
                    $item->teachers_nm = $a->teachers->pluck('code')->filter()->implode(', ') ?: '-',
                    $item->students_nm = $a->students->pluck('name')->implode(', ') ?: '-',
                ]));

        return [
            'subjects'   => $subjects,
            'activities' => $activities,
            'programId'  => $program?->id,
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
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="$dispatch('open-activity-create')" />
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
                        <div class="group flex flex-col items-start gap-0">
                            <div class="flex items-center gap-1">
                                <div class="tooltip tooltip-top" data-tip="{{ $active ? 'Set inactive' : 'Set active' }}">
                                    <button wire:click="toggleActive({{ $activity->id }})"
                                            class="w-2 h-2 rounded-full shrink-0 {{ $active ? 'bg-primary' : 'bg-base-content/20' }}"></button>
                                </div>
                                <div class="tooltip tooltip-top" data-tip="{{ $tooltip }}">
                                    <x-badge value="{{ ($teachers ?: '?') . ($groups ? ' ('.$groups.')' : ' (no student)') . ' ' . $durationStr }}"
                                             class="{{ $active ? 'badge-primary badge-dash' : 'badge-dash !bg-base-200 !text-base-content/40 !border-base-content/20' }} {{ !$groups ? 'border-warning text-warning' : '' }}" />
                                </div>
                            </div>
                            <div class="flex items-center h-0 overflow-hidden group-hover:h-auto group-hover:overflow-visible transition-all">
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

            @scope('cell_action', $row)
                <x-button icon="o-plus-circle" class="btn-ghost btn-sm btn-square"
                          wire:click="$dispatch('open-activity-create', { subjectId: {{ $row->id }} })" tooltip="Add activity" />
            @endscope

        </x-table>
    </x-card>
    @else
    <x-card>
        @php
        $allHeaders = [
            ['key' => 'subject_nm',  'label' => 'Subject',   'class' => 'w-4/12'],
            ['key' => 'type_nm',     'label' => 'Type',      'class' => 'w-1/12'],
            ['key' => 'duration',    'label' => 'Duration',  'class' => 'w-1/12 text-center'],
            ['key' => 'teachers_nm', 'label' => 'Teachers',  'class' => 'w-2/12'],
            ['key' => 'students_nm', 'label' => 'Groups',    'class' => 'w-2/12'],
            ['key' => 'action',      'label' => '',          'class' => 'w-2/12 text-right'],
        ];
        @endphp
        <x-table :striped="true" :headers="$allHeaders" :rows="$activities" with-pagination container-class="overflow-hidden" class="table-fixed">
            @scope('cell_duration', $row)
                <div class="text-center">{{ $row->duration }} hr</div>
            @endscope
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="$dispatch('open-activity-edit', { id: {{ $row->id }} })" tooltip="Edit" />
                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>
    @endif

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
