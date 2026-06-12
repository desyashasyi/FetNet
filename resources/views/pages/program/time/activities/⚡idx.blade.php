<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityTimeConstraint;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.program')] class extends Component
{
    use Toast, HasProgramSemester;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    private function config()
    {
        $program = $this->program();
        if (! $program) return null;
        return Client::with('config')->find($program->client_id)?->config;
    }

    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    public function updatedSemesterId(): void
    {
        $this->persistSemester();
    }

    public function updatedAcademicYearId(): void
    {
        $this->semesterId = null;
        $this->loadProgramSemesters();
        $this->persistSemester();
    }

    public function openAdd(): void
    {
        $this->dispatch('open-activity-add');
    }

    #[On('activity-blocked-changed')]
    public function refreshFromChild(): void
    {
        // empty: presence triggers re-render after child save
    }

    public function with(): array
    {
        $config  = $this->config();
        $program = $this->program();

        $summaryRows = [];
        if ($program && $this->semesterId) {
            $actIds = Activity::where('program_id', $program->id)
                ->whereHas('planning', fn($q) => $q->where('semester_id', $this->semesterId))
                ->pluck('id');

            $blockedAll = ActivityTimeConstraint::whereIn('activity_id', $actIds)
                ->orderBy('day')->orderBy('hour')
                ->get()->groupBy('activity_id');

            if ($blockedAll->isNotEmpty()) {
                $activities = Activity::whereIn('id', $blockedAll->keys())
                    ->with(['planning.subject', 'teachers', 'students', 'type'])
                    ->get()->keyBy('id');

                $summaryRows = $blockedAll->map(function ($slots, $actId) use ($activities) {
                    $a        = $activities->get($actId);
                    $subject  = $a?->planning?->subject;
                    $teachers = $a?->teachers->pluck('code')->filter()->implode('|') ?? '';
                    $groups   = $a?->students->pluck('name')->implode('|') ?? '';
                    return [
                        'id'         => $actId,
                        'subject'    => $subject ? "[{$subject->code}] {$subject->name}" : '?',
                        'detail'     => collect([$a?->type?->name, $teachers ?: '?', $groups])->filter()->implode(' · '),
                        'slots'      => $slots->count(),
                        'blockedMap' => $slots->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                    ];
                })->values()->toArray();
            }
        }

        return [
            'programId'     => $program?->id,
            'numberOfDays'  => $config?->number_of_days  ?? 0,
            'numberOfHours' => $config?->number_of_hours ?? 0,
            'dayLabels'     => $config ? $config->dayLabels()     : [],
            'slotLabels'    => $config ? $config->generateSlots() : [],
            'summaryRows'   => $summaryRows,
        ];
    }
}; ?>

<div>
    <x-header title="Activity Time Constraints" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                      placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions"
                      placeholder="Semester" class="w-48" />
        @endif
        @if($semesterId)
            <div class="w-px h-6 bg-base-content/20 self-center"></div>
            <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openAdd" />
        @endif
    </div>

    @if($numberOfDays === 0 || $numberOfHours === 0)
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            Days per week and slots per day have not been configured.
            Go to <strong>Admin → Data → Basic</strong> first.
        </x-alert>
    @elseif(! $semesterId)
        <x-card>
            <p class="text-center text-base-content/40 py-8 text-sm">Select a semester to continue.</p>
        </x-card>
    @else

        <livewire:pages::program.time.activities.activity-blocked-summary
            :key="'actsum-'.$semesterId"
            :rows="$summaryRows"
            :day-labels="$dayLabels"
            :slot-labels="$slotLabels"
            :number-of-days="$numberOfDays" />

    @endif

    <livewire:pages::program.time.activities.activity-blocked-sheet
        :program-id="$programId"
        :semester-id="$semesterId" />
</div>
