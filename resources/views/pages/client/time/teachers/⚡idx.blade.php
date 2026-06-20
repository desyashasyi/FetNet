<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\Client;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use App\Models\FetNet\TeacherConstraint;
use App\Models\FetNet\TeacherTimeConstraint;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use Toast, HasProgramSemester;

    public ?string $constraintType  = null;
    public string  $target          = 'teacher';
    public ?int    $filterProgramId = null;
    public array   $programOptions  = [];
    /** Teacher-name search for the not-available table (lives in the filter row). */
    public string  $teacherSearch   = '';

    // ── Helpers ───────────────────────────────────────────────────────────────

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

    private function activeProgram(): ?Program
    {
        return $this->filterProgramId ? Program::find($this->filterProgramId) : null;
    }

    private function clusterTeachers(): \Illuminate\Support\Collection
    {
        if ($this->filterProgramId) {
            $program = $this->activeProgram();
            if (! $program) return collect();

            $cluster = Cluster::where('program_id', $program->id)->first();
            if (! $cluster) {
                return Teacher::where('program_id', $program->id)->orderBy('name')->get();
            }

            $ids = Cluster::where('cluster_base_id', $cluster->cluster_base_id)->pluck('program_id');
            return Teacher::whereIn('program_id', $ids)->orderBy('name')->get();
        }

        return Teacher::whereIn('program_id', $this->clientProgramIds())->orderBy('name')->get();
    }

    private function guestTeachers(): \Illuminate\Support\Collection
    {
        if ($this->filterProgramId) {
            return $this->activeProgram()?->guestTeachers()->orderBy('name')->get() ?? collect();
        }
        return collect();
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    public function mount(): void
    {
        $client = $this->client();
        if ($client) {
            $this->mountSemesterContext($client->id);
            $this->programOptions = Program::where('client_id', $client->id)
                ->orderBy('abbrev')->get(['id', 'abbrev', 'name'])
                ->map(fn($p) => ['id' => $p->id, 'name' => $p->abbrev ?: $p->name])
                ->prepend(['id' => '', 'name' => 'All Programs'])
                ->toArray();
        }
    }

    public function updatedFilterProgramId(): void
    {
        $this->constraintType = null;
    }

    public function updatedTarget(): void
    {
        if ($this->target === 'all' && $this->constraintType === 'not_available') {
            $this->constraintType = null;
        }
    }

    public function openAddConstraint(): void
    {
        $this->dispatch('open-constraint-add');
    }

    #[On('constraint-delete-requested')]
    public function deleteConstraintById(int $id): void
    {
        TeacherConstraint::find($id)?->delete();
        $this->warning('Constraint removed.', position: 'toast-top toast-center');
    }

    public function clearNotAvailable(int $teacherId): void
    {
        TeacherTimeConstraint::where('teacher_id', $teacherId)->delete();
        TeacherConstraint::where('teacher_id', $teacherId)
            ->where('constraint_type', 'not_available')->delete();
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
    }

    #[On('constraint-changed')]
    public function refreshFromChild(): void
    {
        // empty body; presence triggers parent re-render after child save
    }

    // ── with() ────────────────────────────────────────────────────────────────

    public function with(): array
    {
        $client  = $this->client();
        $config  = $client?->config;
        $cluster = $this->clusterTeachers();
        $guests  = $this->guestTeachers();
        $program = $this->activeProgram();

        $allTeachers = $cluster->merge($guests)->keyBy('id');

        $constraintRows = [];
        if ($this->constraintType && $this->constraintType !== 'not_available') {
            if ($this->filterProgramId && $program) {
                $tagOptions = ActivityTag::where('program_id', $program->id)
                    ->get()->mapWithKeys(fn($t) => [$t->id => ['name' => $t->name]]);

                $rows = TeacherConstraint::where('program_id', $program->id)
                    ->where('constraint_type', $this->constraintType)->get();

                $constraintRows = $rows->map(function ($row) use ($allTeachers, $tagOptions) {
                    $teacher  = $row->teacher_id ? $allTeachers->get($row->teacher_id) : null;
                    $tag      = $row->tag_id  ? ($tagOptions->get($row->tag_id)['name']  ?? '?') : null;
                    $tag2     = $row->tag2_id ? ($tagOptions->get($row->tag2_id)['name'] ?? '?') : null;
                    $interval = ($row->interval_start && $row->interval_end)
                        ? "slot {$row->interval_start}–{$row->interval_end}" : null;

                    return [
                        'id'           => $row->id,
                        'teacher'      => $teacher ? "[{$teacher->code}] {$teacher->name}" : '(All teachers)',
                        'params'       => collect([$tag, $tag2, $interval])->filter()->implode(', '),
                        'value'        => $row->value,
                        'weight'       => $row->weight,
                        'program_name' => null,
                    ];
                })->values()->toArray();
            } else {
                $programIds   = $this->clientProgramIds();
                $programNames = Program::whereIn('id', $programIds)->get(['id', 'abbrev', 'name'])
                    ->mapWithKeys(fn($p) => [$p->id => $p->abbrev ?: $p->name]);

                $allTagOptions = ActivityTag::whereIn('program_id', $programIds)->get()
                    ->mapWithKeys(fn($t) => [$t->id => ['name' => $t->name]]);

                $allTeachersAll = Teacher::whereIn('program_id', $programIds)->get()->keyBy('id');

                $rows = TeacherConstraint::whereIn('program_id', $programIds)
                    ->where('constraint_type', $this->constraintType)->get();

                $constraintRows = $rows->map(function ($row) use ($allTeachersAll, $allTagOptions, $programNames) {
                    $teacher  = $row->teacher_id ? $allTeachersAll->get($row->teacher_id) : null;
                    $tag      = $row->tag_id  ? ($allTagOptions->get($row->tag_id)['name']  ?? '?') : null;
                    $tag2     = $row->tag2_id ? ($allTagOptions->get($row->tag2_id)['name'] ?? '?') : null;
                    $interval = ($row->interval_start && $row->interval_end)
                        ? "slot {$row->interval_start}–{$row->interval_end}" : null;

                    return [
                        'id'           => $row->id,
                        'teacher'      => $teacher ? "[{$teacher->code}] {$teacher->name}" : '(All teachers)',
                        'params'       => collect([$tag, $tag2, $interval])->filter()->implode(', '),
                        'value'        => $row->value,
                        'weight'       => $row->weight,
                        'program_name' => $programNames->get($row->program_id, '?'),
                    ];
                })->values()->toArray();
            }
        }

        $notAvailableRows = [];
        if ($this->constraintType === 'not_available') {
            if ($this->filterProgramId && $program) {
                $blockedAll = TeacherTimeConstraint::whereIn('teacher_id', $allTeachers->keys())
                    ->get()->groupBy('teacher_id');

                $weights = TeacherConstraint::where('program_id', $program->id)
                    ->where('constraint_type', 'not_available')
                    ->whereNotNull('teacher_id')
                    ->get()->keyBy('teacher_id');

                $notAvailableRows = $allTeachers->map(fn($t) => [
                    'id'           => $t->id,
                    'teacher'      => "[{$t->code}] {$t->name}",
                    'slots'        => $blockedAll->get($t->id, collect())->count(),
                    'blockedMap'   => $blockedAll->get($t->id, collect())
                        ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                    'weight'       => isset($weights[$t->id]) ? (float) $weights[$t->id]->weight : 100.0,
                    'program_name' => null,
                ])->values()->toArray();
            } else {
                $programIds   = $this->clientProgramIds();
                $programNames = Program::whereIn('id', $programIds)->get(['id', 'abbrev', 'name'])
                    ->mapWithKeys(fn($p) => [$p->id => $p->abbrev ?: $p->name]);

                $allTeachersAll = Teacher::whereIn('program_id', $programIds)->get()->keyBy('id');

                $blockedAll = TeacherTimeConstraint::whereIn('teacher_id', $allTeachersAll->keys())
                    ->get()->groupBy('teacher_id');

                $weightsByTeacher = TeacherConstraint::whereIn('program_id', $programIds)
                    ->where('constraint_type', 'not_available')
                    ->whereNotNull('teacher_id')
                    ->get()->keyBy('teacher_id');

                $notAvailableRows = $allTeachersAll->map(fn($t) => [
                    'id'           => $t->id,
                    'teacher'      => "[{$t->code}] {$t->name}",
                    'slots'        => $blockedAll->get($t->id, collect())->count(),
                    'blockedMap'   => $blockedAll->get($t->id, collect())
                        ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                    'weight'       => isset($weightsByTeacher[$t->id]) ? (float) $weightsByTeacher[$t->id]->weight : 100.0,
                    'program_name' => $programNames->get($t->program_id, '?'),
                ])->values()->toArray();
            }
        }

        return [
            'numberOfDays'     => $config?->number_of_days  ?? 0,
            'numberOfHours'    => $config?->number_of_hours ?? 0,
            'dayLabels'        => $config ? $config->dayLabels()     : [],
            'slotLabels'       => $config ? $config->generateSlots() : [],
            'constraintRows'   => $constraintRows,
            'notAvailableRows' => $notAvailableRows,
            'showProgramCol'   => ! $this->filterProgramId,
        ];
    }
}; ?>

<div>
    <x-header title="Teacher Time Constraints" separator />

    {{-- Filter bar --}}
    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                      placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions"
                      placeholder="Semester" class="w-48" />
        @endif
        <x-select wire:model.live="filterProgramId" :options="$programOptions" class="w-max min-w-48" />
        <div class="w-px h-6 bg-base-content/20 self-center"></div>
        <x-choices wire:model.live="target" single
                   :options="[['id'=>'teacher','name'=>'A teacher'],['id'=>'all','name'=>'All teachers']]"
                   class="w-36" />
        <select wire:model.live="constraintType" class="select select-bordered text-sm w-72">
            <option value="">Select constraint</option>

            @if($target === 'teacher' && $filterProgramId)
            <optgroup label="─── Availability ───">
                <option value="not_available">Not Available Times</option>
            </optgroup>
            @endif

            <optgroup label="─── Days ───">
                <option value="max_days_per_week">Max Days per Week</option>
                <option value="min_days_per_week">Min Days per Week</option>
                <option value="hourly_interval_max_days">Working in Hourly Interval Max Days per Week</option>
            </optgroup>

            <optgroup label="─── Daily Hours ───">
                <option value="max_hours_daily">Max Hours Daily</option>
                <option value="min_hours_daily">Min Hours Daily</option>
                <option value="max_hours_daily_tag">Max Hours Daily with Activity Tag</option>
                <option value="min_hours_daily_tag">Min Hours Daily with Activity Tag</option>
                <option value="max_span_per_day">Max Span per Day</option>
            </optgroup>

            <optgroup label="─── Continuous ───">
                <option value="max_hours_continuously">Max Hours Continuously</option>
                <option value="max_hours_continuously_tag">Max Hours Continuously with Activity Tag</option>
            </optgroup>

            <optgroup label="─── Gaps & Rest ───">
                <option value="max_gaps_per_week">Max Gaps per Week</option>
                <option value="max_gaps_per_day">Max Gaps per Day</option>
                <option value="min_gaps_between_activity_tags">Min Gaps Between Activity Tags</option>
                <option value="min_resting_hours">Min Resting Hours</option>
            </optgroup>
        </select>
        @if($constraintType && $constraintType !== 'not_available' && $filterProgramId)
            <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openAddConstraint" />
        @endif
        @if($constraintType === 'not_available')
            <x-input placeholder="Search teacher..." wire:model.live.debounce="teacherSearch"
                     icon="o-magnifying-glass" clearable class="w-56" />
        @endif
    </div>

    @if($numberOfDays === 0 || $numberOfHours === 0)
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            Days per week and slots per day have not been configured.
            Go to <strong>Admin → Data → Basic</strong> first.
        </x-alert>
    @elseif($constraintType)

        @if($constraintType !== 'not_available')
            <livewire:pages::shared.time-teacher-numeric-summary
                :key="'numeric-'.$constraintType.'-'.($filterProgramId ?? 'all')"
                :rows="$constraintRows"
                :show-program-col="$showProgramCol"
                :can-add="(bool) $filterProgramId" />
        @endif

        @if($constraintType === 'not_available')
            <livewire:pages::shared.time-teacher-not-available-summary
                :key="'na-'.($filterProgramId ?? 'all')"
                :rows="$notAvailableRows"
                :day-labels="$dayLabels"
                :slot-labels="$slotLabels"
                :number-of-days="$numberOfDays"
                :search="$teacherSearch"
                :show-program-col="$showProgramCol"
                :can-edit="(bool) $filterProgramId" />
        @endif

    @endif

    <livewire:pages::shared.time-teacher-constraint-sheet
        :key="'tsheet-'.($filterProgramId ?? 0)"
        :program-id="$filterProgramId"
        :constraint-type="$constraintType"
        :target="$target" />
</div>
