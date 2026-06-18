<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Activity;
use App\Models\FetNet\Program;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

/**
 * Space → Activities page for the program: lists the semester's activities with a count
 * of assigned rooms, opens the assign-rooms sheet per activity, and the claim sheet to
 * request shared spaces. Uses HasProgramSemester for the year/semester context. Hosts
 * the assign-rooms-sheet and claim-sheet children.
 */
new #[Layout('layouts.program')] class extends Component
{
    use Toast, WithPagination, HasProgramSemester;

    public string $search = '';

    /** The signed-in user's program; scopes the activities. */
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

    /** Search resets pagination. */
    public function updatedSearch(): void { $this->resetPage(); }

    /** Changing academic year clears the semester, reloads options, persists, resets page. */
    public function updatedAcademicYearId(): void
    {
        $this->semesterId = null;
        $this->loadProgramSemesters();
        $this->persistSemester();
        $this->resetPage();
    }

    /** Persist the chosen semester and reset pagination. */
    public function updatedSemesterId(): void { $this->persistSemester(); $this->resetPage(); }

    /** Open the assign-rooms sheet for one activity. */
    public function openAssignSpace(int $activityId): void
    {
        $this->dispatch('open-assign-rooms', activityId: $activityId);
    }

    /** Open the space claim sheet. */
    public function openClaimModal(): void
    {
        $this->dispatch('open-claim');
    }

    /** Re-render after rooms are assigned/removed in a child sheet. */
    #[On('rooms-changed')]
    public function refreshActivities(): void {}

    /** Paginated semester activities decorated with subject/type/teacher labels + room count. */
    public function with(): array
    {
        $program = $this->program();

        $activities = Activity::with(['planning.subject', 'type', 'teachers', 'students', 'spaces.building'])
            ->when($program && $this->semesterId,
                fn($q) => $q->where('program_id', $program->id)
                             ->whereHas('planning', fn($p) => $p->where('semester_id', $this->semesterId)),
                fn($q) => $q->whereRaw('0=1'))
            ->when($this->search, fn($q) => $q->whereHas('planning', fn($p) => $p->whereHas('subject',
                fn($s) => $s->where('name', 'like', "%{$this->search}%")
                            ->orWhere('code', 'like', "%{$this->search}%"))))
            ->paginate(6)
            ->through(fn($a) => tap($a, fn($item) => [
                $item->subject_nm   = ($a->planning?->subject?->code ?? '?') . ' — ' . ($a->planning?->subject?->name ?? '—'),
                $item->type_nm      = $a->type?->name ?? '—',
                $item->teachers_nm  = $a->teachers->pluck('code')->filter()->implode(', ') ?: '—',
                $item->spaces_count = $a->spaces->count(),
                $item->rooms_badge  = null,
            ]));

        return compact('activities');
    }
}; ?>

<div>
    <x-header title="Space → Activities" subtitle="Assign rooms to each activity" separator>
        <x-slot:actions>
            <x-button label="Manage Spaces" icon="o-building-office" class="btn-ghost btn-sm"
                      wire:click="openClaimModal" />
        </x-slot:actions>
    </x-header>

    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions" placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions" placeholder="Semester" class="w-48" />
        @endif
        <x-input wire:model.live.debounce.300ms="search" placeholder="Search subject..." icon="o-magnifying-glass" class="w-48" clearable />
    </div>

    @if(! $semesterId)
        <x-card>
            <p class="text-center text-base-content/40 py-8 text-sm">Select a semester to continue.</p>
        </x-card>
    @else
        @php
        $headers = [
            ['key' => 'subject_nm',  'label' => 'Subject'],
            ['key' => 'teachers_nm', 'label' => 'Teachers'],
            ['key' => 'rooms_badge', 'label' => 'Rooms', 'class' => 'w-20 text-center'],
        ];
        @endphp
        <x-table :headers="$headers" :rows="$activities" container-class="overflow-hidden" with-pagination>
            @scope('cell_subject_nm', $row)
                <div class="font-medium text-sm">{{ $row->subject_nm }}</div>
                <div class="text-xs text-base-content/40">{{ $row->type_nm }}</div>
            @endscope
            @scope('cell_teachers_nm', $row)
                <span class="text-sm">{{ $row->teachers_nm }}</span>
            @endscope
            @scope('cell_rooms_badge', $row)
                @if($row->spaces_count)
                    <x-badge :value="$row->spaces_count" class="badge-success badge-sm font-semibold" />
                @else
                    <x-badge value="0" class="badge-ghost badge-sm" />
                @endif
            @endscope
            @scope('actions', $row)
                <x-button icon="o-building-office" class="btn-ghost btn-xs"
                          wire:click="openAssignSpace({{ $row->id }})"
                          tooltip="Assign rooms" />
            @endscope
        </x-table>
    @endif

    <livewire:pages::program.space.activities.assign-rooms-sheet />
    <livewire:pages::program.space.activities.claim-sheet />
</div>
