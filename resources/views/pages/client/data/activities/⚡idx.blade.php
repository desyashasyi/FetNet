<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Activity;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Subject;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use WithPagination, Toast, HasProgramSemester;

    public string $search          = '';
    public string $view            = 'all';
    public ?int   $filterProgramId = null;
    public array  $programOptions  = [];
    public int    $activitiesKey   = 0;

    /** Restrict the activity list to activities that have no space assigned yet. */
    public bool   $unassignedOnly  = false;
    /** Quick "study programs that still need space" picker (program id). */
    public ?int   $unassignedProgramId = null;

    public array $headers = [
        ['key' => 'semester', 'label' => 'Sem',     'class' => 'w-1/12 text-center align-top'],
        ['key' => 'code',     'label' => 'Code',    'class' => 'w-1/12 align-top'],
        ['key' => 'name',     'label' => 'Subject', 'class' => 'w-4/12 align-top'],
        ['key' => 'classes',  'label' => 'Classes', 'class' => 'w-6/12 align-top text-right'],
    ];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    private function clientProgramIds(): array
    {
        $client = $this->client();
        if (! $client) return [];
        return Program::where('client_id', $client->id)->pluck('id')->toArray();
    }

    public function mount(): void
    {
        $client = $this->client();
        if ($client) {
            $this->mountSemesterContext($client->id);
            $this->programOptions = Program::where('client_id', $client->id)
                ->orderBy('abbrev')->get(['id', 'abbrev', 'name'])
                ->map(fn($p) => ['id' => $p->id, 'name' => "{$p->abbrev} — {$p->name}"])
                ->toArray();
        }
    }

    public function updatedSemesterId(): void { $this->persistSemester(); $this->resetPage(); }
    public function updatedAcademicYearId(): void
    {
        $this->semesterId = null;
        $this->loadProgramSemesters();
        $this->persistSemester();
        $this->resetPage();
    }
    public function updatedFilterProgramId(): void { $this->resetPage(); }
    public function updatedSearch(): void          { $this->resetPage(); }
    public function updatedView(): void            { $this->resetPage(); }

    /** Toggle the "not yet plotted" filter; viewing them only makes sense in the list view. */
    public function toggleUnassigned(): void
    {
        $this->unassignedOnly = ! $this->unassignedOnly;
        $this->view = 'all';
        $this->resetPage();
    }

    /**
     * Picking a program from the "needs space" selector filters the activity list to that
     * program AND restricts it to activities without a space; clearing it resets both.
     */
    public function updatedUnassignedProgramId($value): void
    {
        $this->filterProgramId = $value ?: null;
        $this->unassignedOnly  = (bool) $value;
        $this->view            = 'all';
        $this->resetPage();
    }

    public function openAssignSpace(int $activityId): void
    {
        $this->dispatch('open-assign-space', activityId: $activityId);
    }

    public function openDetail(int $activityId): void
    {
        $this->dispatch('open-activity-detail', activityId: $activityId);
    }

    #[On('activity-spaces-changed')]
    public function refreshActivities(): void
    {
        $this->activitiesKey++;
    }

    public function with(): array
    {
        $programIds = $this->clientProgramIds();
        $filterIds  = $this->filterProgramId ? [$this->filterProgramId] : $programIds;

        $programMap = Program::whereIn('id', $programIds)->get(['id', 'abbrev'])
            ->mapWithKeys(fn($p) => [$p->id => $p->abbrev])
            ->toArray();

        // Activities with no space yet, grouped by program — drives the "X belum diplot"
        // sign and the "study programs that still need space" quick selector. Scoped to the
        // whole client (not the current program filter) so every program in need is listed.
        $unassignedByProgram = Activity::query()
            ->when($programIds, fn($q) => $q->whereIn('program_id', $programIds), fn($q) => $q->whereRaw('0=1'))
            ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) => $p->where('semester_id', $this->semesterId)))
            ->whereDoesntHave('spaces')
            ->selectRaw('program_id, COUNT(*) as c')
            ->groupBy('program_id')
            ->pluck('c', 'program_id');

        $unassignedTotal          = (int) $unassignedByProgram->sum();
        $unassignedProgramOptions = collect($unassignedByProgram)
            ->map(fn($c, $pid) => ['id' => $pid, 'name' => ($programMap[$pid] ?? '?') . " ({$c})"])
            ->values()->toArray();

        $subjects = Subject::with(['activities' => fn($q) => $q
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) =>
                    $p->where('semester_id', $this->semesterId)))
                ->with(['teachers', 'type', 'students', 'subActivities'])
              ])
                ->when(count($filterIds) && $this->semesterId, fn($q) => $q->whereIn('program_id', $filterIds), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('activityPlannings', fn($p) =>
                    $p->where('semester_id', $this->semesterId)->whereIn('program_id', $filterIds)))
                ->when($this->search, fn($q) => $q
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('code', 'like', "%{$this->search}%"))
                ->orderBy('semester')->orderBy('code')
                ->paginate(6)
                ->through(fn($s) => tap($s, fn($item) => [
                    $item->program_abbrev = $programMap[$s->program_id] ?? '?',
                ]));

        $activities = Activity::query()
                ->select('fetnet_activity.*')
                ->with(['planning.subject', 'type', 'teachers', 'students', 'spaces.building'])
                ->withCount('spaces')
                // Join the plan + subject so the All view sorts by semester then subject code
                // (matching the By-Subject view) instead of by activity id.
                ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'fetnet_activity.planning_id')
                ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
                ->when(count($filterIds) && $this->view === 'all', fn($q) => $q->whereIn('fetnet_activity.program_id', $filterIds), fn($q) => $q->whereRaw('0=1'))
                ->when($this->semesterId, fn($q) => $q->whereHas('planning', fn($p) => $p->where('semester_id', $this->semesterId)))
                ->when($this->unassignedOnly, fn($q) => $q->whereDoesntHave('spaces'))
                ->when($this->search, fn($q) => $q->whereHas('planning', fn($p) => $p->whereHas('subject',
                    fn($s) => $s->where('name', 'like', "%{$this->search}%")
                                ->orWhere('code', 'like', "%{$this->search}%"))))
                ->orderBy('s.semester')->orderBy('s.code')->orderBy('fetnet_activity.id')
                ->paginate(6)
                ->through(fn($a) => tap($a, fn($item) => [
                    $item->subject_nm     = $a->planning?->subject?->code . ' — ' . $a->planning?->subject?->name,
                    $item->type_nm        = $a->type?->name ?? '-',
                    $item->teachers_nm    = $a->teachers->pluck('code')->filter()->implode(', ') ?: '-',
                    $item->students_nm    = $a->students->pluck('name')->implode(', ') ?: '-',
                    $item->program_abbrev = $programMap[$a->program_id] ?? '?',
                    $item->spaces_list    = $a->spaces->map(fn($s) => [
                        'name'     => $s->name,
                        'building' => $s->building?->name,
                    ])->toArray(),
                ]));

        return compact('subjects', 'activities', 'unassignedTotal', 'unassignedProgramOptions');
    }
}; ?>

<div>
    <x-header title="Activities" subtitle="Manage course sessions across all programs" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                      placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions"
                      placeholder="Semester" class="w-48" />
        @endif
        <x-choices single searchable wire:model.live="filterProgramId"
                   :options="$programOptions" placeholder="— All Programs —"
                   clearable class="w-max min-w-48" />
        <x-input placeholder="Search subject..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <div class="join">
            <x-button label="By Subject" class="btn-sm join-item {{ $view === 'subject' ? 'btn-primary' : 'btn-ghost' }}"
                      wire:click="$set('view','subject')" />
            <x-button label="All"        class="btn-sm join-item {{ $view === 'all'     ? 'btn-primary' : 'btn-ghost' }}"
                      wire:click="$set('view','all')" />
        </div>

        {{-- Sign: how many activities still have no space, click to show only those. --}}
        @if($unassignedTotal > 0 || $unassignedOnly)
            <x-button wire:click="toggleUnassigned" icon="o-exclamation-triangle"
                      class="btn-sm {{ $unassignedOnly ? 'btn-warning' : 'btn-ghost border border-warning text-warning' }}">
                {{ $unassignedTotal }} belum diplot
            </x-button>
        @endif

        {{-- Quick picker: study programs that still have activities without a space. --}}
        @if(count($unassignedProgramOptions))
            <x-choices single searchable wire:model.live="unassignedProgramId"
                       :options="$unassignedProgramOptions" placeholder="Prodi belum diplot…"
                       clearable class="w-56" />
        @endif
    </div>

    @if($view === 'subject')
    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$subjects" with-pagination container-class="overflow-hidden" class="table-fixed">

            @scope('cell_semester', $row)
                <div class="text-center">{{ $row->semester ?? '-' }}</div>
            @endscope

            @scope('cell_code', $row)
                {{ $row->code }}
            @endscope

            @scope('cell_classes', $row)
                <div class="flex flex-wrap justify-end gap-y-1 gap-x-2">
                    @forelse($row->activities as $activity)
                        @php
                            $teachers    = $activity->teachers->pluck('code')->filter()->implode('|');
                            $groups      = $activity->students->pluck('name')->implode('|');
                            $tooltip     = $activity->type?->name ?? '';
                            $active      = $activity->active;
                            $subs        = $activity->subActivities;
                            $durationStr = $subs->count() > 1
                                ? $subs->pluck('duration')->implode('+')
                                : (string) $activity->duration;
                        @endphp
                        <div class="flex items-center gap-1">
                            <div class="w-2 h-2 rounded-full shrink-0 {{ $active ? 'bg-primary' : 'bg-base-content/20' }}"></div>
                            <div class="tooltip tooltip-top" data-tip="{{ $tooltip }}">
                                <button wire:click="openDetail({{ $activity->id }})" class="cursor-pointer">
                                    <x-badge value="{{ ($teachers ?: '?') . ($groups ? ' ('.$groups.')' : ' (no student)') . ' ' . $durationStr }}"
                                             class="{{ $active ? 'badge-primary badge-dash' : 'badge-dash !bg-base-200 !text-base-content/40 !border-base-content/20' }} {{ !$groups ? 'border-warning text-warning' : '' }} hover:opacity-75" />
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
    <x-card wire:key="activities-all-{{ $activitiesKey }}">
        @php
        $allHeaders = [
            ['key' => 'program_abbrev', 'label' => 'Program',  'class' => 'w-1/12'],
            ['key' => 'subject_nm',     'label' => 'Subject',  'class' => 'w-5/12'],
            ['key' => 'type_nm',        'label' => 'Type',     'class' => 'w-1/12'],
            ['key' => 'duration',       'label' => 'Dur.',     'class' => 'w-1/12 text-center'],
            ['key' => 'teachers_nm',    'label' => 'Teachers', 'class' => 'w-1/12'],
            ['key' => 'students_nm',    'label' => 'Groups',   'class' => 'w-1/12'],
            ['key' => 'action',         'label' => '',         'class' => 'w-2/12 text-right'],
        ];
        @endphp
        <x-table :striped="true" :headers="$allHeaders" :rows="$activities" with-pagination container-class="overflow-x-auto" class="table-fixed">
            @scope('cell_duration', $row)
                <div class="text-center">{{ $row->duration }}</div>
            @endscope

            @scope('cell_action', $row)
                <div class="flex items-center justify-end gap-1">
                    {{-- Assigned spaces shown as a hover popover (like the workload table). --}}
                    @if($row->spaces_count > 0)
                    <div x-data="{ above: false }"
                         @mouseenter="above = $el.getBoundingClientRect().top < window.innerHeight / 2"
                         :class="above ? 'dropdown-bottom' : 'dropdown-top'"
                         class="dropdown dropdown-hover dropdown-end inline-block">
                        <div tabindex="0" role="button" class="btn btn-ghost btn-xs btn-square text-primary">
                            <x-icon name="o-eye" class="w-4 h-4" />
                        </div>
                        <div tabindex="0"
                             class="dropdown-content z-50 shadow-lg bg-base-100 border border-base-300 rounded-box p-2 mb-1 text-left min-w-max">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-primary mb-1">
                                {{ $row->spaces_count }} assigned space{{ $row->spaces_count > 1 ? 's' : '' }}
                            </p>
                            <div class="space-y-0.5">
                                @foreach($row->spaces_list as $sp)
                                    <div class="text-xs whitespace-nowrap">
                                        <span class="font-semibold">{{ $sp['name'] }}</span>
                                        @if($sp['building'])
                                            <span class="text-base-content/50"> — {{ $sp['building'] }}</span>
                                        @endif
                                    </div>
                                @endforeach
                            </div>
                        </div>
                    </div>
                    @endif
                    <x-button icon="o-building-office" class="btn-ghost btn-xs"
                              wire:click="openAssignSpace({{ $row->id }})">
                        Space @if($row->spaces_count > 0)<span class="ml-1 font-bold text-primary">{{ $row->spaces_count }}</span>@endif
                    </x-button>
                </div>
            @endscope
        </x-table>
    </x-card>
    @endif

    <livewire:pages::client.data.activities.assign-space-sheet />
    <livewire:pages::client.data.activities.activity-detail-sheet />
</div>
