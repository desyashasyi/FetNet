<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\FetNet\StudentConstraint;
use App\Models\FetNet\StudentTimeConstraint;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int    $programId      = null;
    #[Reactive] public ?string $constraintType = null;
    #[Reactive] public string  $target         = 'student';

    public bool   $modal             = false;
    public ?int   $editConstraintId  = null;
    public ?int   $studentId         = null;
    public ?int   $constraintValue   = null;
    public float  $constraintWeight  = 100.0;
    public array  $blocked           = [];
    public array  $studentOptions    = [];

    private static function constraintLabels(): array
    {
        return [
            'not_available'          => 'Not Available Times',
            'max_days_per_week'      => 'Max Days per Week',
            'min_days_per_week'      => 'Min Days per Week',
            'max_hours_daily'        => 'Max Hours Daily',
            'min_hours_daily'        => 'Min Hours Daily',
            'max_span_per_day'       => 'Max Span per Day',
            'max_hours_continuously' => 'Max Hours Continuously',
            'max_gaps_per_week'      => 'Max Gaps per Week',
            'max_gaps_per_day'       => 'Max Gaps per Day',
            'min_resting_hours'      => 'Min Resting Hours',
        ];
    }

    #[Computed]
    public function program(): ?Program
    {
        return $this->programId ? Program::find($this->programId) : null;
    }

    #[Computed]
    public function config()
    {
        $program = $this->program;
        if (! $program) {
            $client = Client::where('user_id', auth()->id())->first();
            return $client?->config;
        }
        return Client::with('config')->find($program->client_id)?->config;
    }

    public function updatedStudentId(): void
    {
        if ($this->constraintType === 'not_available') {
            $this->loadBlocked();
            $this->loadNotAvailableWeight();
        }
    }

    public function searchStudents(string $value = ''): void
    {
        if (! $this->programId) { $this->studentOptions = []; return; }

        $this->studentOptions = Student::where('program_id', $this->programId)
            ->with(['parent.parent'])
            ->where(fn($q) => $q
                ->where('name', 'like', "%{$value}%")
                ->orWhere('id', $this->studentId))
            ->orderBy('name')->limit(20)->get()
            ->map(function ($s) {
                $label = $s->name;
                if ($s->parent) {
                    $label = ($s->parent->parent ? $s->parent->parent->name . ' / ' : '')
                           . $s->parent->name . ' / ' . $s->name;
                }
                return ['id' => $s->id, 'name' => $label];
            })->values()->toArray();
    }

    #[On('open-constraint-add')]
    public function openAdd(): void
    {
        $this->reset(['editConstraintId', 'constraintValue', 'blocked']);
        $this->constraintWeight = 100.0;

        if ($this->target === 'student') {
            $this->searchStudents();
            $this->studentId = collect($this->studentOptions)->first()['id'] ?? null;

            if ($this->constraintType === 'not_available' && $this->studentId) {
                $this->loadBlocked();
                $this->loadNotAvailableWeight();
            }
        } else {
            $this->studentId = null;
        }

        $this->modal = true;
    }

    #[On('open-constraint-edit')]
    public function openEdit(int $id): void
    {
        $row = StudentConstraint::findOrFail($id);

        $this->editConstraintId = $id;
        $this->studentId        = $row->student_id;
        $this->constraintValue  = $row->value;
        $this->constraintWeight = (float) $row->weight;
        $this->searchStudents();
        $this->modal = true;
    }

    #[On('open-not-available-edit')]
    public function openNotAvailable(int $studentId): void
    {
        $this->reset(['editConstraintId', 'blocked']);
        $this->studentId = $studentId;
        $this->searchStudents();
        $this->loadBlocked();
        $this->loadNotAvailableWeight();
        $this->modal = true;
    }

    private function loadBlocked(): void
    {
        if (! $this->studentId) { $this->blocked = []; return; }

        $this->blocked = StudentTimeConstraint::where('student_id', $this->studentId)
            ->get()
            ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])
            ->toArray();
    }

    private function loadNotAvailableWeight(): void
    {
        $program = $this->program;
        if (! $program || ! $this->studentId) { $this->constraintWeight = 100.0; return; }

        $row = StudentConstraint::where('program_id', $program->id)
            ->where('student_id', $this->studentId)
            ->where('constraint_type', 'not_available')
            ->first();

        $this->constraintWeight = $row ? (float) $row->weight : 100.0;
    }

    public function toggle(int $day, int $hour): void
    {
        if (! $this->studentId) return;
        $key = "{$day}-{$hour}";

        if (isset($this->blocked[$key])) {
            StudentTimeConstraint::where('student_id', $this->studentId)
                ->where('day', $day)->where('hour', $hour)->delete();
            unset($this->blocked[$key]);
        } else {
            StudentTimeConstraint::firstOrCreate([
                'student_id' => $this->studentId, 'day' => $day, 'hour' => $hour,
            ]);
            $this->blocked[$key] = true;
        }
        $this->dispatch('constraint-changed');
    }

    public function toggleDay(int $day): void
    {
        if (! $this->studentId) return;
        $hours = range(1, $this->config?->number_of_hours ?? 0);
        $allBlocked = collect($hours)->every(fn($h) => isset($this->blocked["{$day}-{$h}"]));

        if ($allBlocked) {
            StudentTimeConstraint::where('student_id', $this->studentId)->where('day', $day)->delete();
            foreach ($hours as $h) unset($this->blocked["{$day}-{$h}"]);
        } else {
            foreach ($hours as $h) {
                $key = "{$day}-{$h}";
                if (! isset($this->blocked[$key])) {
                    StudentTimeConstraint::firstOrCreate([
                        'student_id' => $this->studentId, 'day' => $day, 'hour' => $h,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('constraint-changed');
    }

    public function toggleSlot(int $hour): void
    {
        if (! $this->studentId) return;
        $total      = $this->config?->number_of_days ?? 0;
        $allBlocked = collect(range(1, $total))->every(fn($d) => isset($this->blocked["{$d}-{$hour}"]));

        if ($allBlocked) {
            StudentTimeConstraint::where('student_id', $this->studentId)->where('hour', $hour)->delete();
            for ($d = 1; $d <= $total; $d++) unset($this->blocked["{$d}-{$hour}"]);
        } else {
            for ($d = 1; $d <= $total; $d++) {
                $key = "{$d}-{$hour}";
                if (! isset($this->blocked[$key])) {
                    StudentTimeConstraint::firstOrCreate([
                        'student_id' => $this->studentId, 'day' => $d, 'hour' => $hour,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('constraint-changed');
    }

    public function saveNotAvailableWeight(): void
    {
        if (! $this->programId) {
            $this->warning('Please select a program first.', position: 'toast-top toast-center');
            return;
        }

        $this->validate(['constraintWeight' => 'required|numeric|min:0|max:100']);
        $program = $this->program;
        if (! $program || ! $this->studentId) return;

        StudentConstraint::updateOrCreate(
            ['program_id' => $program->id, 'student_id' => $this->studentId, 'constraint_type' => 'not_available'],
            ['weight' => $this->constraintWeight, 'value' => 0]
        );
        $this->success('Weight saved.', position: 'toast-top toast-center');
        $this->dispatch('constraint-changed');
    }

    public function saveConstraint(): void
    {
        if (! $this->programId) {
            $this->warning('Please select a program first.', position: 'toast-top toast-center');
            return;
        }

        $this->validate([
            'constraintValue'  => 'required|integer|min:0|max:999',
            'constraintWeight' => 'required|numeric|min:0|max:100',
        ]);

        $program   = $this->program;
        $studentId = $this->target === 'student' ? $this->studentId : null;

        if ($this->editConstraintId) {
            StudentConstraint::findOrFail($this->editConstraintId)->update([
                'student_id' => $studentId,
                'value'      => $this->constraintValue,
                'weight'     => $this->constraintWeight,
            ]);
        } else {
            StudentConstraint::updateOrCreate(
                ['program_id' => $program->id, 'student_id' => $studentId, 'constraint_type' => $this->constraintType],
                ['value' => $this->constraintValue, 'weight' => $this->constraintWeight]
            );
        }

        $this->modal = false;
        $this->success('Constraint saved.', position: 'toast-top toast-center');
        $this->dispatch('constraint-changed');
    }

    public function with(): array
    {
        $config = $this->config;
        return [
            'numberOfDays'     => $config?->number_of_days  ?? 0,
            'numberOfHours'    => $config?->number_of_hours ?? 0,
            'dayLabels'        => $config ? $config->dayLabels()     : [],
            'slotLabels'       => $config ? $config->generateSlots() : [],
            'constraintLabels' => self::constraintLabels(),
        ];
    }
}; ?>

<div>
    <x-modal wire:model="modal"
             :title="($editConstraintId || ($constraintType === 'not_available' && $studentId)) ? 'Edit Constraint' : 'Add Constraint'"
             separator class="modal-bottom"
             box-class="!max-w-2xl mx-auto !rounded-t-2xl !mb-14">

        <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

        @if($constraintType === 'not_available')

            <div class="space-y-4">
                @if($target === 'student')
                    <x-choices label="Student Group" wire:model.live="studentId" single
                               searchable :search-function="'searchStudents'"
                               :options="$studentOptions" placeholder="Select group"
                               class="w-72" />
                @endif

                @if($studentId && $target === 'student')
                    <div class="flex items-center gap-4 text-sm">
                        <span class="flex items-center gap-1.5">
                            <span class="inline-block w-3 h-3 rounded bg-success/20 border border-success/40"></span>
                            Available
                        </span>
                        <span class="flex items-center gap-1.5">
                            <span class="inline-block w-3 h-3 rounded bg-error/30 border border-error/50"></span>
                            Not available
                        </span>
                        <span class="text-xs text-base-content/40">Click header to toggle all</span>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="text-sm border-collapse w-full table-fixed">
                            <colgroup>
                                <col class="w-24">
                                @for($d = 1; $d <= $numberOfDays; $d++)<col>@endfor
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="pb-1 pr-1"></th>
                                    @foreach($dayLabels as $i => $dayLabel)
                                        @php $d = $i + 1; $allDayBlocked = true;
                                        for ($h = 1; $h <= $numberOfHours; $h++) {
                                            if (! isset($blocked["{$d}-{$h}"])) { $allDayBlocked = false; break; }
                                        } @endphp
                                        <th class="pb-1 px-0.5">
                                            <button wire:click="toggleDay({{ $d }})"
                                                    class="w-full py-1 rounded text-xs font-semibold transition-all
                                                           {{ $allDayBlocked
                                                               ? 'bg-error/40 text-error-content hover:bg-error/60'
                                                               : 'bg-base-200 text-base-content/70 hover:bg-base-300' }}">
                                                {{ $dayLabel }}
                                            </button>
                                        </th>
                                    @endforeach
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($slotLabels as $entry)
                                    @php
                                        $h = $entry['idx'];
                                        $allSlotBlocked = true;
                                        for ($d = 1; $d <= $numberOfDays; $d++) {
                                            if (! isset($blocked["{$d}-{$h}"])) { $allSlotBlocked = false; break; }
                                        }
                                    @endphp
                                    @if($entry['break'])
                                        @php
                                            $allBreakAvail = collect(range(1, $numberOfDays))->every(fn($d) => isset($blocked["{$d}-0"]));
                                        @endphp
                                        <tr>
                                            <td class="pr-0.5 py-0.5">
                                                <button wire:click="toggleSlot(0)"
                                                        class="w-full py-1 rounded text-xs font-mono transition-all
                                                               {{ $allBreakAvail
                                                                   ? 'bg-success/40 text-success-content hover:bg-success/60'
                                                                   : 'bg-error/30 text-error hover:bg-error/50' }}">
                                                    {{ $entry['time'] }}
                                                </button>
                                            </td>
                                            @for($d = 1; $d <= $numberOfDays; $d++)
                                                @php $breakAvail = isset($blocked["{$d}-0"]); @endphp
                                                <td class="px-0.5 py-0.5">
                                                    <button wire:click="toggle({{ $d }}, 0)"
                                                            wire:loading.attr="disabled"
                                                            class="w-full h-7 rounded transition-all
                                                                   {{ $breakAvail
                                                                       ? 'bg-success/20 border border-success/30 hover:bg-success/40'
                                                                       : 'bg-error/30 border border-error/40 hover:bg-error/50' }}">
                                                    </button>
                                                </td>
                                            @endfor
                                        </tr>
                                    @else
                                        <tr>
                                            <td class="pr-0.5 py-0.5">
                                                <button wire:click="toggleSlot({{ $h }})"
                                                        class="w-full py-1 rounded text-xs font-mono transition-all
                                                               {{ $allSlotBlocked
                                                                   ? 'bg-error/40 text-error-content hover:bg-error/60'
                                                                   : 'bg-base-200 text-base-content/60 hover:bg-base-300' }}">
                                                    {{ $entry['time'] }}
                                                </button>
                                            </td>
                                            @for($d = 1; $d <= $numberOfDays; $d++)
                                                @php $isBlocked = isset($blocked["{$d}-{$h}"]); @endphp
                                                <td class="px-0.5 py-0.5">
                                                    <button wire:click="toggle({{ $d }}, {{ $h }})"
                                                            wire:loading.attr="disabled"
                                                            class="w-full h-7 rounded transition-all
                                                                   {{ $isBlocked
                                                                       ? 'bg-error/30 border border-error/40 hover:bg-error/50'
                                                                       : 'bg-success/20 border border-success/30 hover:bg-success/40' }}">
                                                    </button>
                                                </td>
                                            @endfor
                                        </tr>
                                    @endif
                                @endforeach
                            </tbody>
                        </table>
                    </div>

                    @if($programId)
                    <div class="pt-1 space-y-1">
                        <p class="text-sm font-semibold">Weight (%) <span class="font-normal text-xs text-base-content/40">— 100 = hard constraint</span></p>
                        <div class="flex items-center gap-2">
                            <input wire:model="constraintWeight" type="number" min="0" max="100" step="0.01"
                                   class="input input-bordered input-sm w-28" />
                            <x-button label="Save Weight" icon="o-check-circle"
                                      wire:click="saveNotAvailableWeight"
                                      class="btn-sm btn-primary" spinner="saveNotAvailableWeight" />
                        </div>
                    </div>
                    @endif
                @endif
            </div>

        @else

            @php
                $label = $constraintLabels[$constraintType] ?? $constraintType;
                $hint = match($constraintType) {
                    'max_days_per_week'      => 'Max days per week (0–' . $numberOfDays . ')',
                    'min_days_per_week'      => 'Min days per week (0–' . $numberOfDays . ')',
                    'max_hours_daily'        => 'Max slots per day (0–' . $numberOfHours . ')',
                    'min_hours_daily'        => 'Min slots per day (0–' . $numberOfHours . ')',
                    'max_span_per_day'       => 'Max span (first–last activity) per day',
                    'max_hours_continuously' => 'Max consecutive slots without a break',
                    'max_gaps_per_week'      => 'Max unused slots between lessons per week',
                    'max_gaps_per_day'       => 'Max unused slots between lessons per day',
                    'min_resting_hours'      => 'Min slots between last lesson of one day and first of next',
                    default                  => '',
                };
            @endphp

            <x-form wire:submit="saveConstraint" class="space-y-4">

                @if($target === 'student')
                    <x-choices label="Student Group" wire:model.live="studentId" single
                               searchable :search-function="'searchStudents'"
                               :options="$studentOptions" placeholder="Select group"
                               class="w-72" />
                @endif

                <div class="flex gap-3 items-start">
                    <div class="flex-1">
                        <x-input label="{{ $label }}" wire:model="constraintValue"
                                 type="number" min="0" max="999"
                                 hint="{{ $hint }}" placeholder="Enter value" />
                    </div>
                    <x-input label="Weight (%)" wire:model="constraintWeight"
                             type="number" min="0" max="100" step="0.01" class="w-28"
                             hint="100 = hard" />
                </div>

                <x-slot:actions>
                    <x-button label="Cancel" icon="o-x-circle" wire:click="$set('modal', false)" />
                    <x-button label="Save" icon="o-check-circle" type="submit"
                              class="btn-primary" spinner="saveConstraint" />
                </x-slot:actions>

            </x-form>

        @endif

    </x-modal>
</div>
