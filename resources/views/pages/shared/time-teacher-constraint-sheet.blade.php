<?php

use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\Client;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use App\Models\FetNet\TeacherConstraint;
use App\Models\FetNet\TeacherTimeConstraint;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int    $programId       = null;
    #[Reactive] public ?string $constraintType  = null;
    #[Reactive] public string  $target          = 'teacher';

    public bool   $modal             = false;
    public ?int   $editConstraintId  = null;
    public ?int   $teacherId         = null;
    public ?int   $constraintValue   = null;
    public float  $constraintWeight  = 100.0;
    public ?int   $tagId             = null;
    public ?int   $tag2Id            = null;
    public ?int   $intervalStart     = null;
    public ?int   $intervalEnd       = null;
    public array  $blocked           = [];
    public array  $teacherOptions    = [];

    // ── Static labels ─────────────────────────────────────────────────────────

    private static function tagConstraints(): array
    {
        return ['max_hours_daily_tag', 'min_hours_daily_tag', 'max_hours_continuously_tag'];
    }

    private static function dualTagConstraints(): array
    {
        return ['min_gaps_between_activity_tags'];
    }

    private static function constraintLabels(): array
    {
        return [
            'not_available'                  => 'Not Available Times',
            'max_days_per_week'              => 'Max Days per Week',
            'min_days_per_week'              => 'Min Days per Week',
            'hourly_interval_max_days'       => 'Working in Hourly Interval Max Days per Week',
            'max_hours_daily'                => 'Max Hours Daily',
            'min_hours_daily'                => 'Min Hours Daily',
            'max_hours_daily_tag'            => 'Max Hours Daily with Activity Tag',
            'min_hours_daily_tag'            => 'Min Hours Daily with Activity Tag',
            'max_span_per_day'               => 'Max Span per Day',
            'max_hours_continuously'         => 'Max Hours Continuously',
            'max_hours_continuously_tag'     => 'Max Hours Continuously with Activity Tag',
            'max_gaps_per_week'              => 'Max Gaps per Week',
            'max_gaps_per_day'               => 'Max Gaps per Day',
            'min_gaps_between_activity_tags' => 'Min Gaps Between Activity Tags',
            'min_resting_hours'              => 'Min Resting Hours',
        ];
    }

    // ── Computed: program-derived data ────────────────────────────────────────

    #[Computed]
    public function program(): ?Program
    {
        return $this->programId ? Program::find($this->programId) : null;
    }

    #[Computed]
    public function config()
    {
        if ($this->programId) {
            $program = Program::find($this->programId);
            if ($program) {
                return Client::with('config')->find($program->client_id)?->config;
            }
        }
        $client = Client::where('user_id', auth()->id())->first();
        return $client?->config;
    }

    #[Computed]
    public function tagOptions(): array
    {
        if (! $this->programId) return [];
        return ActivityTag::where('program_id', $this->programId)->orderBy('name')->get()
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->name])
            ->values()->toArray();
    }

    #[Computed]
    public function slotOptions(): array
    {
        return collect($this->config?->generateSlots() ?? [])
            ->filter(fn($s) => ! $s['break'])
            ->map(fn($s) => ['id' => $s['idx'], 'name' => $s['time']])
            ->values()->toArray();
    }

    // ── Lifecycle / hooks ─────────────────────────────────────────────────────

    public function updatedTeacherId(): void
    {
        if ($this->constraintType === 'not_available') {
            $this->loadBlocked();
            $this->loadNotAvailableWeight();
        }
    }

    public function searchTeachers(string $value = ''): void
    {
        if (! $this->programId) { $this->teacherOptions = []; return; }

        $program    = $this->program;
        $cluster    = Cluster::where('program_id', $program->id)->first();
        $clusterIds = $cluster
            ? Cluster::where('cluster_base_id', $cluster->cluster_base_id)->pluck('program_id')->toArray()
            : [$program->id];
        $guestIds   = $program->guestTeachers()->pluck('teacher_id')->toArray();

        $options = Teacher::whereIn('program_id', $clusterIds)
            ->where(fn($q) => $q
                ->where('name', 'like', "%{$value}%")
                ->orWhere('code', 'like', "%{$value}%")
                ->orWhere('id', $this->teacherId))
            ->orderBy('name')->limit(15)->get()
            ->map(fn($t) => ['id' => $t->id, 'name' => "[{$t->code}] {$t->name}"])
            ->values()->toArray();

        if (! empty($guestIds)) {
            $guests = Teacher::whereIn('id', $guestIds)
                ->where(fn($q) => $q
                    ->where('name', 'like', "%{$value}%")
                    ->orWhere('code', 'like', "%{$value}%")
                    ->orWhere('id', $this->teacherId))
                ->orderBy('name')->limit(15)->get()
                ->map(fn($t) => ['id' => $t->id, 'name' => "[{$t->code}] {$t->name} (guest)"])
                ->toArray();
            $options = array_merge($options, $guests);
        }

        $this->teacherOptions = $options;
    }

    // ── Open from parent events ───────────────────────────────────────────────

    #[On('open-constraint-add')]
    public function openAdd(): void
    {
        $this->reset(['editConstraintId', 'constraintValue', 'tagId', 'tag2Id',
                      'intervalStart', 'intervalEnd', 'blocked']);
        $this->constraintWeight = 100.0;

        if ($this->target === 'teacher') {
            $this->searchTeachers();
            $this->teacherId = collect($this->teacherOptions)->first()['id'] ?? null;

            if ($this->constraintType === 'not_available' && $this->teacherId) {
                $this->loadBlocked();
                $this->loadNotAvailableWeight();
            }
        } else {
            $this->teacherId = null;
        }

        $this->modal = true;
    }

    #[On('open-constraint-edit')]
    public function openEdit(int $id): void
    {
        $row = TeacherConstraint::findOrFail($id);

        $this->editConstraintId  = $id;
        $this->teacherId         = $row->teacher_id;
        $this->constraintValue   = $row->value;
        $this->constraintWeight  = (float) $row->weight;
        $this->tagId             = $row->tag_id;
        $this->tag2Id            = $row->tag2_id;
        $this->intervalStart     = $row->interval_start;
        $this->intervalEnd       = $row->interval_end;
        $this->searchTeachers();
        $this->modal             = true;
    }

    #[On('open-not-available-edit')]
    public function openNotAvailable(int $teacherId): void
    {
        $this->reset(['editConstraintId', 'blocked']);
        $this->teacherId = $teacherId;
        $this->searchTeachers();
        $this->loadBlocked();
        $this->loadNotAvailableWeight();
        $this->modal = true;
    }

    // ── Not-available grid state ──────────────────────────────────────────────

    private function loadBlocked(): void
    {
        if (! $this->teacherId) { $this->blocked = []; return; }

        $this->blocked = TeacherTimeConstraint::where('teacher_id', $this->teacherId)
            ->get()
            ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])
            ->toArray();
    }

    private function loadNotAvailableWeight(): void
    {
        $program = $this->program;
        if (! $program || ! $this->teacherId) { $this->constraintWeight = 100.0; return; }

        $row = TeacherConstraint::where('program_id', $program->id)
            ->where('teacher_id', $this->teacherId)
            ->where('constraint_type', 'not_available')
            ->first();

        $this->constraintWeight = $row ? (float) $row->weight : 100.0;
    }

    public function toggle(int $day, int $hour): void
    {
        if (! $this->teacherId) return;
        $key = "{$day}-{$hour}";

        if (isset($this->blocked[$key])) {
            TeacherTimeConstraint::where('teacher_id', $this->teacherId)
                ->where('day', $day)->where('hour', $hour)->delete();
            unset($this->blocked[$key]);
        } else {
            TeacherTimeConstraint::firstOrCreate([
                'teacher_id' => $this->teacherId, 'day' => $day, 'hour' => $hour,
            ]);
            $this->blocked[$key] = true;
        }
        $this->dispatch('constraint-changed');
    }

    public function toggleDay(int $day): void
    {
        if (! $this->teacherId) return;
        $hours = range(1, $this->config?->number_of_hours ?? 0);

        $allBlocked = collect($hours)->every(fn($h) => isset($this->blocked["{$day}-{$h}"]));

        if ($allBlocked) {
            TeacherTimeConstraint::where('teacher_id', $this->teacherId)->where('day', $day)->delete();
            foreach ($hours as $h) unset($this->blocked["{$day}-{$h}"]);
        } else {
            foreach ($hours as $h) {
                $key = "{$day}-{$h}";
                if (! isset($this->blocked[$key])) {
                    TeacherTimeConstraint::firstOrCreate([
                        'teacher_id' => $this->teacherId, 'day' => $day, 'hour' => $h,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('constraint-changed');
    }

    public function toggleSlot(int $hour): void
    {
        if (! $this->teacherId) return;
        $total      = $this->config?->number_of_days ?? 0;
        $allBlocked = collect(range(1, $total))->every(fn($d) => isset($this->blocked["{$d}-{$hour}"]));

        if ($allBlocked) {
            TeacherTimeConstraint::where('teacher_id', $this->teacherId)->where('hour', $hour)->delete();
            for ($d = 1; $d <= $total; $d++) unset($this->blocked["{$d}-{$hour}"]);
        } else {
            for ($d = 1; $d <= $total; $d++) {
                $key = "{$d}-{$hour}";
                if (! isset($this->blocked[$key])) {
                    TeacherTimeConstraint::firstOrCreate([
                        'teacher_id' => $this->teacherId, 'day' => $d, 'hour' => $hour,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('constraint-changed');
    }

    // ── Save methods ──────────────────────────────────────────────────────────

    public function saveNotAvailableWeight(): void
    {
        if (! $this->programId) {
            $this->warning('Select a program first.', position: 'toast-top toast-center');
            return;
        }

        $this->validate(['constraintWeight' => 'required|numeric|min:0|max:100']);

        $program = $this->program;
        if (! $program || ! $this->teacherId) return;

        TeacherConstraint::updateOrCreate(
            ['program_id' => $program->id, 'teacher_id' => $this->teacherId, 'constraint_type' => 'not_available'],
            ['weight' => $this->constraintWeight, 'value' => 0]
        );
        $this->success('Weight saved.', position: 'toast-top toast-center');
        $this->dispatch('constraint-changed');
    }

    public function saveConstraint(): void
    {
        if (! $this->programId) {
            $this->warning('Select a program first.', position: 'toast-top toast-center');
            return;
        }

        $this->validate([
            'constraintValue'  => 'required|integer|min:0|max:999',
            'constraintWeight' => 'required|numeric|min:0|max:100',
        ]);

        $program   = $this->program;
        $teacherId = $this->target === 'teacher' ? $this->teacherId : null;

        $isTag      = in_array($this->constraintType, self::tagConstraints());
        $isDualTag  = in_array($this->constraintType, self::dualTagConstraints());
        $isInterval = $this->constraintType === 'hourly_interval_max_days';

        if ($this->editConstraintId) {
            TeacherConstraint::findOrFail($this->editConstraintId)->update([
                'teacher_id'     => $teacherId,
                'value'          => $this->constraintValue,
                'weight'         => $this->constraintWeight,
                'tag_id'         => ($isTag || $isDualTag) ? $this->tagId  : null,
                'tag2_id'        => $isDualTag             ? $this->tag2Id : null,
                'interval_start' => $isInterval            ? $this->intervalStart : null,
                'interval_end'   => $isInterval            ? $this->intervalEnd   : null,
            ]);
        } else {
            $key = [
                'program_id'      => $program->id,
                'teacher_id'      => $teacherId,
                'constraint_type' => $this->constraintType,
            ];
            if ($isTag || $isDualTag) $key['tag_id']  = $this->tagId;
            if ($isDualTag)           $key['tag2_id'] = $this->tag2Id;
            if ($isInterval) {
                $key['interval_start'] = $this->intervalStart;
                $key['interval_end']   = $this->intervalEnd;
            }
            TeacherConstraint::updateOrCreate($key, [
                'value'  => $this->constraintValue,
                'weight' => $this->constraintWeight,
            ]);
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
            'tagOptions'       => $this->tagOptions,
            'slotOptions'      => $this->slotOptions,
        ];
    }
}; ?>

<div>
    <x-modal wire:model="modal"
             :title="($editConstraintId || ($constraintType === 'not_available' && $teacherId)) ? 'Edit Constraint' : 'Add Constraint'"
             separator class="modal-bottom"
             box-class="!max-w-2xl mx-auto !rounded-t-2xl !mb-14">

        <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

        @if($constraintType === 'not_available')

            <div class="space-y-4">
                @if($target === 'teacher')
                    <x-choices label="Teacher" wire:model.live="teacherId" single
                               searchable :search-function="'searchTeachers'"
                               :options="$teacherOptions" placeholder="Select teacher"
                               class="w-72" />
                @endif

                @if($teacherId && $target === 'teacher')
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
            </div>

        @else

            @php
                $label      = $constraintLabels[$constraintType] ?? $constraintType;
                $isTag      = in_array($constraintType, ['max_hours_daily_tag', 'min_hours_daily_tag', 'max_hours_continuously_tag']);
                $isDualTag  = $constraintType === 'min_gaps_between_activity_tags';
                $isInterval = $constraintType === 'hourly_interval_max_days';

                $hint = match($constraintType) {
                    'max_days_per_week'              => 'Max days per week (0–' . $numberOfDays . ')',
                    'min_days_per_week'              => 'Min days per week (0–' . $numberOfDays . ')',
                    'hourly_interval_max_days'       => 'Max days per week working within the selected slot interval',
                    'max_hours_daily'                => 'Max teaching slots per day (0–' . $numberOfHours . ')',
                    'min_hours_daily'                => 'Min teaching slots per day (0–' . $numberOfHours . ')',
                    'max_hours_daily_tag'            => 'Max slots per day for activities with the selected tag',
                    'min_hours_daily_tag'            => 'Min slots per day for activities with the selected tag',
                    'max_span_per_day'               => 'Max span (first–last activity) per day',
                    'max_hours_continuously'         => 'Max consecutive slots without a break',
                    'max_hours_continuously_tag'     => 'Max consecutive slots for activities with the selected tag',
                    'max_gaps_per_week'              => 'Max unused slots between lessons per week',
                    'max_gaps_per_day'               => 'Max unused slots between lessons per day',
                    'min_gaps_between_activity_tags' => 'Min gap slots between the two activity tags',
                    'min_resting_hours'              => 'Min slots between last lesson of one day and first of next',
                    default                          => '',
                };
            @endphp

            <x-form wire:submit="saveConstraint" class="space-y-4">

                @if($target === 'teacher')
                    <x-choices label="Teacher" wire:model.live="teacherId" single
                               searchable :search-function="'searchTeachers'"
                               :options="$teacherOptions" placeholder="Select teacher"
                               class="w-72" />
                @endif

                @if($isTag || $isDualTag)
                    <div class="{{ $isDualTag ? 'grid grid-cols-2 gap-3' : '' }}">
                        <x-choices label="{{ $isDualTag ? 'Activity Tag 1' : 'Activity Tag' }}"
                                   wire:model.live="tagId" single
                                   :options="$tagOptions" placeholder="Select tag" />
                        @if($isDualTag)
                            <x-choices label="Activity Tag 2"
                                       wire:model.live="tag2Id" single
                                       :options="$tagOptions" placeholder="Select tag" />
                        @endif
                    </div>
                @endif

                @if($isInterval)
                    <div class="grid grid-cols-2 gap-3">
                        <x-choices label="From slot" wire:model.live="intervalStart" single
                                   :options="$slotOptions" placeholder="Start slot" />
                        <x-choices label="To slot" wire:model.live="intervalEnd" single
                                   :options="$slotOptions" placeholder="End slot" />
                    </div>
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
