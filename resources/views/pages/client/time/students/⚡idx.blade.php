<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\FetNet\StudentConstraint;
use App\Models\FetNet\StudentTimeConstraint;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use Toast, HasProgramSemester;

    public ?string $constraintType  = null;
    public string  $target          = 'student';
    public ?int    $filterProgramId = null;
    public array   $programOptions  = [];

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

    private function allStudents(): \Illuminate\Support\Collection
    {
        if ($this->filterProgramId) {
            return Student::where('program_id', $this->filterProgramId)
                ->with(['parent.parent'])
                ->orderBy('name')->get();
        }

        $programIds = $this->clientProgramIds();
        if (empty($programIds)) return collect();

        return Student::whereIn('program_id', $programIds)
            ->with(['parent.parent'])
            ->orderBy('name')->get();
    }

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
        StudentConstraint::find($id)?->delete();
        $this->warning('Constraint removed.', position: 'toast-top toast-center');
    }

    public function clearNotAvailable(int $studentId): void
    {
        StudentTimeConstraint::where('student_id', $studentId)->delete();
        StudentConstraint::where('student_id', $studentId)
            ->where('constraint_type', 'not_available')->delete();
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
    }

    #[On('constraint-changed')]
    public function refreshFromChild(): void
    {
        // empty: presence triggers re-render after child save
    }

    public function with(): array
    {
        $client  = $this->client();
        $config  = $client?->config;
        $program = $this->filterProgramId ? Program::find($this->filterProgramId) : null;

        $allStudents = $this->allStudents()->keyBy('id');

        $labelMap = $allStudents->map(function ($s) {
            $label = $s->name;
            if ($s->parent) {
                $label = ($s->parent->parent ? $s->parent->parent->name . ' / ' : '')
                       . $s->parent->name . ' / ' . $s->name;
            }
            return $label;
        });

        $constraintRows   = [];
        $notAvailableRows = [];

        if ($this->constraintType && $this->constraintType !== 'not_available') {
            if ($this->filterProgramId && $program) {
                $rows = StudentConstraint::where('program_id', $program->id)
                    ->where('constraint_type', $this->constraintType)->get();

                $constraintRows = $rows->map(fn($row) => [
                    'id'           => $row->id,
                    'student'      => $row->student_id ? ($labelMap->get($row->student_id) ?? '?') : '(All groups)',
                    'value'        => $row->value,
                    'weight'       => $row->weight,
                    'program_name' => null,
                ])->values()->toArray();
            } else {
                $programIds   = $this->clientProgramIds();
                $programNames = Program::whereIn('id', $programIds)->get(['id', 'abbrev', 'name'])
                    ->mapWithKeys(fn($p) => [$p->id => $p->abbrev ?: $p->name]);

                $rows = StudentConstraint::whereIn('program_id', $programIds)
                    ->where('constraint_type', $this->constraintType)->get();

                $constraintRows = $rows->map(fn($row) => [
                    'id'           => $row->id,
                    'student'      => $row->student_id ? ($labelMap->get($row->student_id) ?? '?') : '(All groups)',
                    'value'        => $row->value,
                    'weight'       => $row->weight,
                    'program_name' => $programNames->get($row->program_id, '?'),
                ])->values()->toArray();
            }
        }

        if ($this->constraintType === 'not_available') {
            $blockedAll = StudentTimeConstraint::whereIn('student_id', $allStudents->keys())
                ->orderBy('day')->orderBy('hour')
                ->get()->groupBy('student_id');

            if ($this->filterProgramId && $program) {
                $weights = StudentConstraint::where('program_id', $program->id)
                    ->where('constraint_type', 'not_available')
                    ->whereNotNull('student_id')
                    ->get()->keyBy('student_id');

                $notAvailableRows = $allStudents->map(function ($s) use ($labelMap, $blockedAll, $weights) {
                    $blocked = $blockedAll->get($s->id, collect());
                    return [
                        'id'           => $s->id,
                        'student'      => $labelMap->get($s->id) ?? $s->name,
                        'slots'        => $blocked->count(),
                        'blockedMap'   => $blocked->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                        'weight'       => isset($weights[$s->id]) ? (float) $weights[$s->id]->weight : 100.0,
                        'program_name' => null,
                    ];
                })->values()->toArray();
            } else {
                $programIds   = $this->clientProgramIds();
                $programNames = Program::whereIn('id', $programIds)->get(['id', 'abbrev', 'name'])
                    ->mapWithKeys(fn($p) => [$p->id => $p->abbrev ?: $p->name]);

                $allWeights = StudentConstraint::whereIn('program_id', $programIds)
                    ->where('constraint_type', 'not_available')
                    ->whereNotNull('student_id')
                    ->get()->keyBy('student_id');

                $notAvailableRows = $allStudents->map(function ($s) use ($labelMap, $blockedAll, $allWeights, $programNames) {
                    $blocked = $blockedAll->get($s->id, collect());
                    return [
                        'id'           => $s->id,
                        'student'      => $labelMap->get($s->id) ?? $s->name,
                        'slots'        => $blocked->count(),
                        'blockedMap'   => $blocked->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                        'weight'       => isset($allWeights[$s->id]) ? (float) $allWeights[$s->id]->weight : 100.0,
                        'program_name' => $programNames->get($s->program_id, '?'),
                    ];
                })->values()->toArray();
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
    <x-header title="Student Time Constraints" separator />

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
                   :options="[['id'=>'student','name'=>'A group'],['id'=>'all','name'=>'All groups']]"
                   class="w-36" />
        <select wire:model.live="constraintType" class="select select-bordered text-sm w-72">
            <option value="">Select constraint</option>

            @if($target === 'student' && $filterProgramId)
            <optgroup label="─── Availability ───">
                <option value="not_available">Not Available Times</option>
            </optgroup>
            @endif

            <optgroup label="─── Days ───">
                <option value="max_days_per_week">Max Days per Week</option>
                <option value="min_days_per_week">Min Days per Week</option>
            </optgroup>

            <optgroup label="─── Daily Hours ───">
                <option value="max_hours_daily">Max Hours Daily</option>
                <option value="min_hours_daily">Min Hours Daily</option>
                <option value="max_span_per_day">Max Span per Day</option>
            </optgroup>

            <optgroup label="─── Continuous ───">
                <option value="max_hours_continuously">Max Hours Continuously</option>
            </optgroup>

            <optgroup label="─── Gaps & Rest ───">
                <option value="max_gaps_per_week">Max Gaps per Week</option>
                <option value="max_gaps_per_day">Max Gaps per Day</option>
                <option value="min_resting_hours">Min Resting Hours</option>
            </optgroup>
        </select>
        @if($constraintType && $constraintType !== 'not_available' && $filterProgramId)
            <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openAddConstraint" />
        @endif
    </div>

    @if($numberOfDays === 0 || $numberOfHours === 0)
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            Days per week and slots per day have not been configured.
            Go to <strong>Admin → Data → Basic</strong> first.
        </x-alert>
    @elseif($constraintType)

        @if($constraintType !== 'not_available')
            <livewire:pages::shared.time-student-numeric-summary
                :key="'snumeric-'.$constraintType.'-'.($filterProgramId ?? 'all')"
                :rows="$constraintRows"
                :show-program-col="$showProgramCol"
                :can-add="(bool) $filterProgramId" />
        @endif

        @if($constraintType === 'not_available')
            <livewire:pages::shared.time-student-not-available-summary
                :key="'sna-'.($filterProgramId ?? 'all')"
                :rows="$notAvailableRows"
                :day-labels="$dayLabels"
                :slot-labels="$slotLabels"
                :number-of-days="$numberOfDays"
                :show-program-col="$showProgramCol"
                :can-edit="(bool) $filterProgramId" />
        @endif

    @endif

    <livewire:pages::shared.time-student-constraint-sheet
        :program-id="$filterProgramId"
        :constraint-type="$constraintType"
        :target="$target" />
</div>
