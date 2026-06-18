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

/**
 * Student time-constraints page: pick a target (one group / all groups) and a constraint
 * type (not-available slots, or a numeric rule like max hours daily) and manage the
 * StudentConstraint / StudentTimeConstraint rows for the program. Renders the shared
 * numeric or not-available summary and hosts the shared constraint sheet. Uses
 * HasProgramSemester for the year/semester context.
 */
new #[Layout('layouts.program')] class extends Component
{
    use Toast, HasProgramSemester;

    public ?string $constraintType = null;
    public string  $target         = 'student';

    /** The signed-in user's program. */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** The client's scheduling config (day/hour layout). */
    private function config()
    {
        $program = $this->program();
        if (! $program) return null;
        return Client::with('config')->find($program->client_id)?->config;
    }

    /** All student nodes for the program (with two ancestors) for label building. */
    private function allStudents(): \Illuminate\Support\Collection
    {
        $program = $this->program();
        if (! $program) return collect();
        return Student::where('program_id', $program->id)
            ->with(['parent.parent'])
            ->orderBy('name')->get();
    }

    /** Seed the academic-year/semester context for the program's client. */
    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    /** "All groups" can't have not-available slots — reset the type if so. */
    public function updatedTarget(): void
    {
        if ($this->target === 'all' && $this->constraintType === 'not_available') {
            $this->constraintType = null;
        }
    }

    /** Open the constraint sheet to add a numeric constraint. */
    public function openAddConstraint(): void
    {
        $this->dispatch('open-constraint-add');
    }

    /** Delete a numeric constraint by id (from the summary row). */
    #[On('constraint-delete-requested')]
    public function deleteConstraintById(int $id): void
    {
        StudentConstraint::find($id)?->delete();
        $this->warning('Constraint removed.', position: 'toast-top toast-center');
    }

    /** Clear a student group's not-available slots and the matching weight row. */
    public function clearNotAvailable(int $studentId): void
    {
        StudentTimeConstraint::where('student_id', $studentId)->delete();
        StudentConstraint::where('student_id', $studentId)
            ->where('constraint_type', 'not_available')->delete();
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
    }

    /** Re-render after the constraint sheet saves. */
    #[On('constraint-changed')]
    public function refreshFromChild(): void
    {
        // empty: presence triggers re-render after child save
    }

    /**
     * View data: config layout plus, for the chosen constraint type, either numeric
     * constraint rows or per-group not-available summaries (with blocked maps + weights).
     */
    public function with(): array
    {
        $program = $this->program();
        $config  = $this->config();
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

        if ($program && $this->constraintType && $this->constraintType !== 'not_available') {
            $rows = StudentConstraint::where('program_id', $program->id)
                ->where('constraint_type', $this->constraintType)->get();

            $constraintRows = $rows->map(fn($row) => [
                'id'           => $row->id,
                'student'      => $row->student_id ? ($labelMap->get($row->student_id) ?? '?') : '(All groups)',
                'value'        => $row->value,
                'weight'       => $row->weight,
                'program_name' => null,
            ])->values()->toArray();
        }

        if ($program && $this->constraintType === 'not_available') {
            $blockedAll = StudentTimeConstraint::whereIn('student_id', $allStudents->keys())
                ->orderBy('day')->orderBy('hour')
                ->get()->groupBy('student_id');

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
        }

        return [
            'programId'        => $program?->id,
            'numberOfDays'     => $config?->number_of_days  ?? 0,
            'numberOfHours'    => $config?->number_of_hours ?? 0,
            'dayLabels'        => $config ? $config->dayLabels()     : [],
            'slotLabels'       => $config ? $config->generateSlots() : [],
            'constraintRows'   => $constraintRows,
            'notAvailableRows' => $notAvailableRows,
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
        <div class="w-px h-6 bg-base-content/20 self-center"></div>
        <x-choices wire:model.live="target" single
                   :options="[['id'=>'student','name'=>'A group'],['id'=>'all','name'=>'All groups']]"
                   class="w-36" />
        <select wire:model.live="constraintType" class="select select-bordered text-sm w-72">
            <option value="">Select constraint</option>

            @if($target === 'student')
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
        @if($constraintType && $constraintType !== 'not_available')
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
                :key="'snumeric-'.$constraintType.'-'.$programId"
                :rows="$constraintRows"
                :show-program-col="false"
                :can-add="true" />
        @endif

        @if($constraintType === 'not_available')
            <livewire:pages::shared.time-student-not-available-summary
                :key="'sna-'.$programId"
                :rows="$notAvailableRows"
                :day-labels="$dayLabels"
                :slot-labels="$slotLabels"
                :number-of-days="$numberOfDays"
                :show-program-col="false"
                :can-edit="true" />
        @endif

    @endif

    <livewire:pages::shared.time-student-constraint-sheet
        :program-id="$programId"
        :constraint-type="$constraintType"
        :target="$target" />
</div>
