<?php

use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Semester;
use App\Models\FetNet\TimetableSlot;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

new #[Layout('layouts.operator')] class extends Component
{
    #[Url] public ?int $sem = null;

    #[Computed]
    public function program()
    {
        return auth()->user()?->program?->load('client');
    }

    #[Computed]
    public function semesters()
    {
        $clientId = $this->program?->client_id;
        if (! $clientId) return collect();

        // Only semesters that have a published compile for this client.
        return Semester::whereIn('id', FetCompile::where('client_id', $clientId)
                ->whereNotNull('published_at')
                ->pluck('semester_id'))
            ->orderByDesc('id')
            ->get();
    }

    #[Computed]
    public function slots()
    {
        if (! $this->program || ! $this->sem) return collect();

        return TimetableSlot::query()
            ->where('client_id', $this->program->client_id)
            ->where('semester_id', $this->sem)
            ->whereHas('activity', fn ($q) => $q->where('program_id', $this->program->id))
            ->with(['activity.subject', 'activity.teachers', 'room'])
            ->orderBy('day_index')
            ->orderBy('hour_index')
            ->get();
    }
}; ?>

<div>
    <x-header title="Compiled Timetable" subtitle="{{ $this->program?->abbrev }}" separator />

    @if(! $this->program)
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            No program assigned. Contact your administrator.
        </x-alert>
    @elseif($this->semesters->isEmpty())
        <x-alert icon="o-information-circle" class="alert-info">
            No published timetable available yet.
        </x-alert>
    @else
        <x-card shadow separator class="mb-4">
            <x-choices-offline label="Semester" wire:model.live="sem"
                               :options="$this->semesters->map(fn($s) => ['id' => $s->id, 'name' => ($s->name ?? ('Semester '.$s->semester)).' '.($s->year ?? '')])"
                               option-value="id" option-label="name" single />
        </x-card>

        @if($sem)
            <x-card title="Schedule" shadow separator>
                @if($this->slots->isEmpty())
                    <p class="text-sm text-base-content/60">No slots in this semester.</p>
                @else
                    <x-table :headers="[
                        ['key' => 'day_index',  'label' => 'Day'],
                        ['key' => 'hour_index', 'label' => 'Hour'],
                        ['key' => 'subject',    'label' => 'Subject'],
                        ['key' => 'teacher',    'label' => 'Teacher'],
                        ['key' => 'room',       'label' => 'Room'],
                    ]" :rows="$this->slots->map(fn($s) => [
                        'day_index'  => $s->day_index,
                        'hour_index' => $s->hour_index,
                        'subject'    => $s->activity?->subject?->name ?? '-',
                        'teacher'    => $s->activity?->teachers?->pluck('name')->join(', ') ?: '-',
                        'room'       => $s->room?->code ?? '-',
                    ])" container-class="overflow-hidden" />
                @endif
            </x-card>
        @endif
    @endif
</div>
