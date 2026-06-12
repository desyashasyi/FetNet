<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\TimetableSlot;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;

new class extends Component
{
    #[Reactive] public ?int $clientId   = null;
    #[Reactive] public ?int $semesterId = null;

    public bool $open = false;

    public string $view = 'grid'; // grid | teacher | student | room

    public ?int $programFilterId = null;
    public ?int $teacherFilterId = null;
    public ?int $studentFilterId = null;
    public ?int $roomFilterId    = null;

    public function updatedProgramFilterId(): void
    {
        // Clear downstream filter so user does not see a stale teacher
        // that does not belong to the newly-picked program.
        $this->teacherFilterId = null;
        unset($this->teacherOptions);
    }

    #[On('open-timetable-view')]
    public function openIt(): void
    {
        // Invalidate cached computed properties so the modal reflects the
        // freshly-saved slots from the latest solver run.
        unset(
            $this->placedSlots, $this->gridIndex,
            $this->teacherOptions, $this->studentOptions, $this->roomOptions,
            $this->config, $this->dayLabels, $this->hourLabels,
        );
        $this->open = true;
    }

    public function close(): void
    {
        $this->open = false;
    }

    #[Computed]
    public function config(): ?ClientConfig
    {
        return $this->clientId ? ClientConfig::where('client_id', $this->clientId)->first() : null;
    }

    #[Computed]
    public function dayLabels(): array
    {
        return $this->config?->dayLabels() ?: ['Mon','Tue','Wed','Thu','Fri'];
    }

    #[Computed]
    public function hourLabels(): array
    {
        $slots = $this->config?->generateSlots() ?: [];
        $bookable = array_values(array_filter($slots, fn($s) => ! ($s['break'] ?? false)));
        if (empty($bookable)) {
            $out = [];
            for ($i = 1; $i <= 8; $i++) $out[] = sprintf('%02d:00', 7 + $i - 1);
            return $out;
        }
        return array_map(fn($s) => explode('–', $s['time'] ?? '')[0] ?? '?', $bookable);
    }

    #[Computed]
    public function placedSlots()
    {
        if (! $this->clientId || ! $this->semesterId) return collect();

        return TimetableSlot::with([
                'activity.planning.subject:id,code,name',
                'activity.teachers:id,code,name',
                'activity.students:id,name',
                'room:id,code,name',
            ])
            ->where('client_id', $this->clientId)
            ->where('semester_id', $this->semesterId)
            ->whereNotNull('day_index')
            ->whereNotNull('hour_index')
            ->get();
    }

    /** @return array<int, array<int, array>>  [day_index][hour_index] => slots[] */
    #[Computed]
    public function gridIndex(): array
    {
        $out = [];
        $slots = match ($this->view) {
            'teacher' => $this->teacherFilterId
                ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->teachers->contains('id', $this->teacherFilterId))
                : ($this->programFilterId
                    ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->program_id === $this->programFilterId)
                    : collect()),
            'student' => $this->studentFilterId
                ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->students->contains('id', $this->studentFilterId))
                : collect(),
            'room'    => $this->roomFilterId
                ? collect($this->placedSlots)->filter(fn($s) => $s->room_id === $this->roomFilterId)
                : collect(),
            default   => $this->placedSlots,
        };
        foreach ($slots as $s) {
            $out[$s->day_index][$s->hour_index][] = $s;
        }
        return $out;
    }

    #[Computed]
    public function programOptions(): array
    {
        return collect($this->placedSlots)
            ->map(fn($s) => $s->activity)
            ->filter()
            ->unique('program_id')
            ->map(fn($a) => [
                'id'   => $a->program_id,
                'name' => \App\Models\FetNet\Program::find($a->program_id)?->abbrev
                       ?? \App\Models\FetNet\Program::find($a->program_id)?->name
                       ?? "P{$a->program_id}",
            ])
            ->filter(fn($r) => $r['id'])
            ->sortBy('name')
            ->values()->toArray();
    }

    #[Computed]
    public function teacherOptions(): array
    {
        $slots = $this->programFilterId
            ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->program_id === $this->programFilterId)
            : collect($this->placedSlots);
        return $slots
            ->flatMap(fn($s) => $s->activity?->teachers ?? collect())
            ->unique('id')
            ->sortBy('code')
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->code ?: $t->name])
            ->values()->toArray();
    }

    #[Computed]
    public function studentOptions(): array
    {
        return $this->placedSlots
            ->flatMap(fn($s) => $s->activity?->students ?? collect())
            ->unique('id')
            ->sortBy('name')
            ->map(fn($s) => ['id' => $s->id, 'name' => $s->name])
            ->values()->toArray();
    }

    #[Computed]
    public function roomOptions(): array
    {
        return $this->placedSlots
            ->filter(fn($s) => $s->room)
            ->pluck('room')->unique('id')
            ->sortBy('code')
            ->map(fn($r) => ['id' => $r->id, 'name' => $r->code ?: $r->name])
            ->values()->toArray();
    }
}; ?>

<div>
    <x-modal wire:model="open"
             title="Generated Timetable"
             subtitle="{{ collect($this->placedSlots)->count() }} placed slot{{ collect($this->placedSlots)->count() === 1 ? '' : 's' }}"
             box-class="!max-w-[98vw] !w-[98vw]"
             persistent>

        @if(count($this->placedSlots) === 0)
            <div class="flex flex-col items-center py-12 text-base-content/40 gap-2">
                <x-icon name="o-table-cells" class="w-10 h-10" />
                <p class="text-sm">No timetable saved yet for this semester.</p>
            </div>
        @else
        <x-tabs wire:model.live="view" class="mb-3">
            <x-tab name="grid"    label="Grid"        icon="o-squares-2x2" />
            <x-tab name="teacher" label="By Teacher"  icon="o-user" />
            <x-tab name="student" label="By Student"  icon="o-user-group" />
            <x-tab name="room"    label="By Room"     icon="o-building-office" />
        </x-tabs>

            @if($view === 'teacher')
                <div class="flex flex-wrap items-center gap-2 mb-3">
                    <x-choices single clearable
                               wire:model.live="programFilterId"
                               :options="$this->programOptions"
                               placeholder="Pick a program"
                               class="w-max min-w-60" />
                    <x-choices single clearable
                               wire:model.live="teacherFilterId"
                               :options="$this->teacherOptions"
                               placeholder="Pick a teacher"
                               class="w-max min-w-60" />
                </div>
            @elseif($view === 'student')
                <x-choices single clearable
                           wire:model.live="studentFilterId"
                           :options="$this->studentOptions"
                           placeholder="Pick a student group"
                           class="w-max min-w-60 mb-3" />
            @elseif($view === 'room')
                <x-choices single clearable
                           wire:model.live="roomFilterId"
                           :options="$this->roomOptions"
                           placeholder="Pick a room"
                           class="w-max min-w-60 mb-3" />
            @endif

            <div class="overflow-x-auto overflow-hidden">
                <table class="table border-collapse w-full">
                    <thead>
                        <tr class="text-base-content/70 text-sm">
                            <th class="w-24 bg-base-200">Day</th>
                            @foreach($this->hourLabels as $hour)
                                <th class="bg-base-200 text-center font-mono">{{ $hour }}</th>
                            @endforeach
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($this->dayLabels as $dIdx => $day)
                            <tr class="align-top">
                                <td class="font-semibold bg-base-200/50 text-base">{{ $day }}</td>
                                @foreach($this->hourLabels as $hIdx => $hour)
                                    @php($cell = $this->gridIndex[$dIdx + 1][$hIdx + 1] ?? [])
                                    <td class="border border-base-300 p-1.5 min-w-40 align-top">
                                        @foreach($cell as $slot)
                                            <div class="bg-primary/10 border-l-4 border-primary rounded px-2 py-1.5 mb-1 leading-snug">
                                                <div class="font-bold text-sm">
                                                    {{ $slot->activity?->planning?->subject?->code ?? 'subj?' }}
                                                </div>
                                                @if($slot->activity?->teachers->isNotEmpty())
                                                    <div class="text-sm text-base-content/80">
                                                        {{ $slot->activity->teachers->pluck('code')->filter()->implode(', ') ?: $slot->activity->teachers->pluck('name')->implode(', ') }}
                                                    </div>
                                                @endif
                                                @if($slot->room)
                                                    <div class="text-sm font-mono text-base-content/70">
                                                        @ {{ $slot->room->code ?? $slot->room->name }}
                                                    </div>
                                                @else
                                                    <div class="text-sm text-warning italic">no room</div>
                                                @endif
                                                @if($slot->activity?->students->isNotEmpty() && $view === 'grid')
                                                    <div class="text-xs text-base-content/60 mt-0.5 truncate" title="{{ $slot->activity->students->pluck('name')->implode(', ') }}">
                                                        {{ $slot->activity->students->pluck('name')->implode(', ') }}
                                                    </div>
                                                @endif
                                            </div>
                                        @endforeach
                                    </td>
                                @endforeach
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @endif

        <x-slot:actions>
            <x-button label="Close" wire:click="close" />
        </x-slot:actions>
    </x-modal>
</div>
