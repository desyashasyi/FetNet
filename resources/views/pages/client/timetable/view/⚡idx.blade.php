<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\TimetableSlot;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.print')] class extends Component
{
    use Toast;

    #[Url] public ?int $sem  = null;
    #[Url] public string $view = 'grid'; // grid | teacher | student | room

    #[Url] public string $mode = 'grid'; // grid | table

    public ?int $programFilterId = null;
    public ?int $teacherFilterId = null;
    public ?int $studentFilterId = null;
    public ?int $roomFilterId    = null;

    public function updatedProgramFilterId(): void
    {
        $this->teacherFilterId = null;
        $this->studentFilterId = null;
        unset($this->teacherOptions, $this->studentOptions);
    }

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    /**
     * Lock / unlock a placed slot. A locked slot is pinned to its day/hour AND room on the
     * next compile (FetXmlBuilder emits Permanently_Locked=true for both), so re-generating
     * the timetable keeps it in place. Scoped to the signed-in client's own slots.
     */
    public function toggleLock(int $slotId): void
    {
        $slot = TimetableSlot::where('client_id', $this->clientId)->find($slotId);
        if (! $slot) { $this->error('Slot not found.', position: 'toast-top toast-center'); return; }

        $slot->update(['locked' => ! $slot->locked]);
        unset($this->placedSlots);

        $slot->locked
            ? $this->success('Slot locked — it will stay put on the next generate.', position: 'toast-top toast-center')
            : $this->warning('Slot unlocked.', position: 'toast-top toast-center');
    }

    #[Computed]
    public function clientId(): ?int
    {
        return $this->client()?->id;
    }

    #[Computed]
    public function semesterId(): ?int
    {
        return $this->sem;
    }

    #[Computed]
    public function semester(): ?Semester
    {
        return $this->sem ? Semester::with('academicYear')->find($this->sem) : null;
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
            for ($i = 1; $i <= 8; $i++) {
                $start = sprintf('%02d:00', 7 + $i - 1);
                $end   = sprintf('%02d:00', 7 + $i);
                $out[] = "{$start}–{$end}";
            }
            return $out;
        }
        // ClientConfig::generateSlots() emits {time:"HH:MM–HH:MM", break:bool}.
        return array_map(fn($s) => $s['time'] ?? '?', $bookable);
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
                : ($this->programFilterId
                    ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->program_id === $this->programFilterId)
                    : collect()),
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

    /** Flat list of slots in display order, used by Table mode. */
    #[Computed]
    public function flatSlots(): array
    {
        $bag = collect();
        foreach ($this->gridIndex as $dIdx => $hours) {
            foreach ($hours as $hIdx => $cells) {
                foreach ($cells as $s) {
                    $bag->push([
                        'id'         => $s->id,
                        'locked'     => (bool) $s->locked,
                        'day_idx'    => $dIdx,
                        'hour_idx'   => $hIdx,
                        'day'        => $this->dayLabels[$dIdx - 1]  ?? "Day {$dIdx}",
                        'hour'       => $this->hourLabels[$hIdx - 1] ?? "H{$hIdx}",
                        'subj_code'  => $s->activity?->planning?->subject?->code ?? '—',
                        'subj_name'  => $s->activity?->planning?->subject?->name ?? '—',
                        'teacher'    => $s->activity?->teachers->pluck('code')->filter()->implode(', ')
                                     ?: ($s->activity?->teachers->pluck('name')->implode(', ') ?? '—'),
                        'students'   => $s->activity?->students->pluck('name')->implode(', ') ?? '—',
                        'room'       => $s->room ? ($s->room->code ?? $s->room->name) : '—',
                    ]);
                }
            }
        }
        return $bag->sortBy(['day_idx', 'hour_idx'])->values()->toArray();
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
                'name' => Program::find($a->program_id)?->abbrev
                       ?? Program::find($a->program_id)?->name
                       ?? "P{$a->program_id}",
            ])
            ->filter(fn($r) => $r['id'])
            ->sortBy('name')->values()->toArray();
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
        $slots = $this->programFilterId
            ? collect($this->placedSlots)->filter(fn($s) => $s->activity?->program_id === $this->programFilterId)
            : collect($this->placedSlots);
        return $slots
            ->flatMap(fn($s) => $s->activity?->students ?? collect())
            ->unique('id')
            ->sortBy('name')
            ->map(fn($s) => ['id' => $s->id, 'name' => $s->name])
            ->values()->toArray();
    }

#[Computed]
    public function roomOptions(): array
    {
        return collect($this->placedSlots)
            ->filter(fn($s) => $s->room)
            ->pluck('room')->unique('id')
            ->sortBy('code')
            ->map(fn($r) => ['id' => $r->id, 'name' => $r->code ?: $r->name])
            ->values()->toArray();
    }

}; ?>

<div>
    {{-- Top toolbar (compact, no main nav) --}}
    <div class="flex flex-wrap items-center gap-3 mb-4 pb-3 border-b border-base-300">
        <x-icon name="o-table-cells" class="w-6 h-6 text-primary" />
        <div>
            <h1 class="text-lg font-bold leading-tight">Generated Timetable</h1>
            <p class="text-xs text-base-content/60">
                {{ $this->semester?->academicYear?->label }}
                @if($this->semester) — Semester {{ $this->semester->semester }} ({{ $this->semester->name }}) @endif
                · {{ collect($this->placedSlots)->count() }} slots
            </p>
        </div>

        <div class="grow"></div>

        <x-tabs wire:model.live="view">
            <x-tab name="grid"    label="All"        icon="o-squares-2x2" />
            <x-tab name="teacher" label="By Teacher" icon="o-user" />
            <x-tab name="student" label="By Student" icon="o-user-group" />
            <x-tab name="room"    label="By Room"    icon="o-building-office" />
        </x-tabs>

        {{-- Mode toggle: Grid (day × hour matrix) vs Table (flat list) --}}
        <div class="join">
            <x-button icon="o-squares-2x2" wire:click="$set('mode','grid')"
                      class="btn-sm join-item {{ $mode === 'grid' ? 'btn-primary' : 'btn-ghost' }}"
                      tooltip="Grid mode" />
            <x-button icon="o-bars-3" wire:click="$set('mode','table')"
                      class="btn-sm join-item {{ $mode === 'table' ? 'btn-primary' : 'btn-ghost' }}"
                      tooltip="Table mode" />
        </div>

        <x-button icon="o-printer" class="btn-ghost btn-sm btn-square"
                  tooltip="Print" onclick="window.print()" />
    </div>

    {{-- Filters --}}
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
        <div class="flex flex-wrap items-center gap-2 mb-3">
            <x-choices single clearable
                       wire:model.live="programFilterId"
                       :options="$this->programOptions"
                       placeholder="Pick a program"
                       class="w-max min-w-60" />
            <x-choices single clearable
                       wire:model.live="studentFilterId"
                       :options="$this->studentOptions"
                       placeholder="Pick a student group"
                       class="w-max min-w-60" />
        </div>
    @elseif($view === 'room')
        <x-choices single clearable
                   wire:model.live="roomFilterId"
                   :options="$this->roomOptions"
                   placeholder="Pick a room"
                   class="w-max min-w-60 mb-3" />
    @endif

    @if(count($this->placedSlots) === 0)
        <div class="flex flex-col items-center py-16 text-base-content/40 gap-2">
            <x-icon name="o-table-cells" class="w-12 h-12" />
            <p class="text-sm">No timetable saved for this semester.</p>
        </div>
    @elseif($mode === 'table')
        <table class="table table-sm border-collapse w-full">
            <thead>
                <tr class="text-base-content/70 text-sm bg-base-200">
                    <th class="w-24">Day</th>
                    <th class="w-32">Hour</th>
                    <th class="w-24">Code</th>
                    <th>Subject</th>
                    <th class="w-32">Teacher</th>
                    <th>Class / Students</th>
                    <th class="w-40">Room</th>
                    @if($view === 'teacher')
                        <th class="w-20 text-center print:hidden">Lock</th>
                    @endif
                </tr>
            </thead>
            <tbody>
                @php($prevDay = null)
                @forelse($this->flatSlots as $r)
                    @php($firstOfDay = $r['day'] !== $prevDay)
                    @php($zebra = ($r['day_idx'] % 2 === 0) ? 'bg-base-200/40' : '')
                    <tr class="{{ $zebra }} hover:bg-primary/5 {{ $firstOfDay && $prevDay !== null ? 'border-t-2 border-base-300' : '' }}">
                        <td class="text-sm font-semibold">
                            {{ $firstOfDay ? $r['day'] : '' }}
                        </td>
                        <td class="text-sm font-mono">{{ $r['hour'] }}</td>
                        <td class="text-sm font-mono font-semibold">{{ $r['subj_code'] }}</td>
                        <td class="text-sm">{{ $r['subj_name'] }}</td>
                        <td class="text-sm">{{ $r['teacher'] }}</td>
                        <td class="text-sm">{{ $r['students'] }}</td>
                        <td class="text-sm font-mono">{{ $r['room'] }}</td>
                        @if($view === 'teacher')
                            <td class="text-center print:hidden">
                                <x-button :icon="$r['locked'] ? 'o-lock-closed' : 'o-lock-open'"
                                          class="btn-ghost btn-xs btn-square {{ $r['locked'] ? 'text-primary' : 'text-base-content/30' }}"
                                          wire:click="toggleLock({{ $r['id'] }})"
                                          spinner="toggleLock({{ $r['id'] }})"
                                          :tooltip="$r['locked'] ? 'Locked — click to unlock' : 'Lock this slot in place'" />
                            </td>
                        @endif
                    </tr>
                    @php($prevDay = $r['day'])
                @empty
                    <tr><td colspan="{{ $view === 'teacher' ? 8 : 7 }}" class="text-center text-sm text-base-content/40 py-6">
                        No slots in current filter. Pick a program, teacher, student, or room first.
                    </td></tr>
                @endforelse
            </tbody>
        </table>
    @else
        <table class="table border-collapse w-full table-fixed">
            <thead>
                <tr class="text-base-content/70 text-sm">
                    <th class="w-20 bg-base-200">Hour</th>
                    @foreach($this->dayLabels as $day)
                        <th class="bg-base-200 text-center text-base font-semibold">{{ $day }}</th>
                    @endforeach
                </tr>
            </thead>
            <tbody>
                @foreach($this->hourLabels as $hIdx => $hour)
                    <tr class="align-top">
                        <td class="font-mono bg-base-200/50 text-sm">{{ $hour }}</td>
                        @foreach($this->dayLabels as $dIdx => $day)
                            @php($cell = $this->gridIndex[$dIdx + 1][$hIdx + 1] ?? [])
                            <td class="border border-base-300 p-1.5 align-top">
                                @foreach($cell as $slot)
                                    <div class="bg-primary/10 border-l-4 rounded px-2 py-1.5 mb-1 leading-snug
                                                {{ $slot->locked ? 'border-warning bg-warning/10' : 'border-primary' }}">
                                        <div class="flex items-start justify-between gap-1">
                                            <div class="font-bold text-sm">
                                                {{ $slot->activity?->planning?->subject?->code ?? 'subj?' }}
                                            </div>
                                            @if($view === 'teacher')
                                                <x-button :icon="$slot->locked ? 'o-lock-closed' : 'o-lock-open'"
                                                          class="btn-ghost btn-xs btn-square -mr-1 -mt-0.5 print:hidden {{ $slot->locked ? 'text-warning' : 'text-base-content/30' }}"
                                                          wire:click="toggleLock({{ $slot->id }})"
                                                          spinner="toggleLock({{ $slot->id }})"
                                                          :tooltip="$slot->locked ? 'Locked — click to unlock' : 'Lock this slot in place'" />
                                            @endif
                                        </div>
                                        @if($slot->activity?->teachers->isNotEmpty())
                                            <div class="text-sm text-base-content/80">
                                                {{ $slot->activity->teachers->pluck('code')->filter()->implode(', ') ?: $slot->activity->teachers->pluck('name')->implode(', ') }}
                                            </div>
                                        @endif
                                        @if($slot->room)
                                            <div class="text-sm font-mono text-base-content/70 truncate"
                                                 title="{{ $slot->room->code ?? $slot->room->name }}">
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
    @endif
</div>
