<?php

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityTimeConstraint;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int $programId  = null;
    #[Reactive] public ?int $semesterId = null;

    public bool  $modal           = false;
    public ?int  $activityId      = null;
    public array $blocked         = [];
    public array $activityOptions = [];

    #[Computed]
    public function config()
    {
        $program = $this->programId ? Program::find($this->programId) : null;
        if (! $program) return null;
        return Client::with('config')->find($program->client_id)?->config;
    }

    public function searchActivities(string $value = ''): void
    {
        if (! $this->programId || ! $this->semesterId) { $this->activityOptions = []; return; }

        $this->activityOptions = Activity::where('program_id', $this->programId)
            ->whereHas('planning', fn($q) => $q->where('semester_id', $this->semesterId))
            ->with(['planning.subject', 'teachers', 'students', 'type'])
            ->when($value, fn($q) => $q->whereHas('planning', fn($p) => $p->whereHas('subject',
                fn($s) => $s->where('name', 'like', "%{$value}%")->orWhere('code', 'like', "%{$value}%")
            )))
            ->orderBy('id')->limit(30)->get()
            ->map(function ($a) {
                $subject  = $a->planning?->subject;
                $teachers = $a->teachers->pluck('code')->filter()->implode('|');
                $groups   = $a->students->pluck('name')->implode('|');
                $label    = ($subject ? "[{$subject->code}] {$subject->name}" : '?');
                $detail   = collect([$a->type?->name, $teachers ?: '?', $groups])->filter()->implode(' · ');
                return ['id' => $a->id, 'name' => $label . ' — ' . $detail];
            })->values()->toArray();
    }

    public function updatedActivityId(): void
    {
        $this->loadBlocked();
    }

    #[On('open-activity-add')]
    public function openAdd(): void
    {
        $this->reset(['activityId', 'blocked']);
        $this->searchActivities();
        $this->modal = true;
    }

    #[On('open-activity-edit')]
    public function openEdit(int $activityId): void
    {
        $this->activityId = $activityId;
        $this->searchActivities();
        $this->loadBlocked();
        $this->modal = true;
    }

    private function loadBlocked(): void
    {
        if (! $this->activityId) { $this->blocked = []; return; }

        $this->blocked = ActivityTimeConstraint::where('activity_id', $this->activityId)
            ->get()
            ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])
            ->toArray();
    }

    public function toggle(int $day, int $hour): void
    {
        if (! $this->activityId) return;
        $key = "{$day}-{$hour}";

        if (isset($this->blocked[$key])) {
            ActivityTimeConstraint::where('activity_id', $this->activityId)
                ->where('day', $day)->where('hour', $hour)->delete();
            unset($this->blocked[$key]);
        } else {
            ActivityTimeConstraint::firstOrCreate([
                'activity_id' => $this->activityId, 'day' => $day, 'hour' => $hour,
            ]);
            $this->blocked[$key] = true;
        }
        $this->dispatch('activity-blocked-changed');
    }

    public function toggleDay(int $day): void
    {
        if (! $this->activityId) return;
        $hours = range(1, $this->config?->number_of_hours ?? 0);
        $allBlocked = collect($hours)->every(fn($h) => isset($this->blocked["{$day}-{$h}"]));

        if ($allBlocked) {
            ActivityTimeConstraint::where('activity_id', $this->activityId)->where('day', $day)->delete();
            foreach ($hours as $h) unset($this->blocked["{$day}-{$h}"]);
        } else {
            foreach ($hours as $h) {
                $key = "{$day}-{$h}";
                if (! isset($this->blocked[$key])) {
                    ActivityTimeConstraint::firstOrCreate([
                        'activity_id' => $this->activityId, 'day' => $day, 'hour' => $h,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('activity-blocked-changed');
    }

    public function toggleSlot(int $hour): void
    {
        if (! $this->activityId) return;
        $total      = $this->config?->number_of_days ?? 0;
        $allBlocked = collect(range(1, $total))->every(fn($d) => isset($this->blocked["{$d}-{$hour}"]));

        if ($allBlocked) {
            ActivityTimeConstraint::where('activity_id', $this->activityId)->where('hour', $hour)->delete();
            for ($d = 1; $d <= $total; $d++) unset($this->blocked["{$d}-{$hour}"]);
        } else {
            for ($d = 1; $d <= $total; $d++) {
                $key = "{$d}-{$hour}";
                if (! isset($this->blocked[$key])) {
                    ActivityTimeConstraint::firstOrCreate([
                        'activity_id' => $this->activityId, 'day' => $d, 'hour' => $hour,
                    ]);
                    $this->blocked[$key] = true;
                }
            }
        }
        $this->dispatch('activity-blocked-changed');
    }

    public function clearBlocked(): void
    {
        if (! $this->activityId) return;
        ActivityTimeConstraint::where('activity_id', $this->activityId)->delete();
        $this->blocked = [];
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
        $this->dispatch('activity-blocked-changed');
    }

    public function with(): array
    {
        $config = $this->config;
        return [
            'numberOfDays'  => $config?->number_of_days  ?? 0,
            'numberOfHours' => $config?->number_of_hours ?? 0,
            'dayLabels'     => $config ? $config->dayLabels()     : [],
            'slotLabels'    => $config ? $config->generateSlots() : [],
        ];
    }
}; ?>

<div>
    <x-modal wire:model="modal"
             :title="$activityId ? 'Edit Not-Available Slots' : 'Add Not-Available Slots'"
             separator class="modal-bottom"
             box-class="!max-w-3xl mx-auto !rounded-t-2xl">

        <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

        @if(! $activityId)
            <div class="py-4">
                <x-choices label="Activity" wire:model.live="activityId" single
                           searchable :search-function="'searchActivities'"
                           :options="$activityOptions" placeholder="Search by subject code or name..."
                           no-result-text="No activity found" class="w-full" />
                <p class="text-base-content/40 text-xs mt-2 text-center">
                    Type subject code or name to search
                </p>
            </div>
        @else
            <div class="space-y-4">
                <x-choices label="Activity" wire:model.live="activityId" single
                           searchable :search-function="'searchActivities'"
                           :options="$activityOptions" placeholder="Search by subject code or name..."
                           no-result-text="No activity found" />

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

                <div class="flex justify-between items-center pt-1">
                    <x-button label="Clear All" icon="o-x-mark" class="btn-ghost btn-sm text-error"
                              wire:click="clearBlocked"
                              wire:confirm="Clear all blocked slots for this activity?" />
                </div>
            </div>
        @endif

    </x-modal>
</div>
