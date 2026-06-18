<?php

use App\Models\FetNet\Program;
use Livewire\Attributes\Layout;
use Livewire\Component;

/**
 * Operator dashboard: shows the operator's assigned program (with university/faculty)
 * and a link to its timetable, or a warning when no program is assigned.
 */
new #[Layout('layouts.operator')] class extends Component
{
    /** The operator's assigned program with its client's university + faculty. */
    public function with(): array
    {
        return [
            'program' => auth()->user()?->program?->load(['client.university', 'client.faculty']),
        ];
    }
}; ?>

<div>
    <x-header title="Operator Dashboard" separator />

    @if($program)
        <div class="grid grid-cols-1 gap-4 lg:grid-cols-3 mb-6">
            <x-stat title="University" value="{{ $program->client?->university?->code ?? '-' }}"  icon="o-academic-cap"      color="text-primary" />
            <x-stat title="Faculty"    value="{{ $program->client?->faculty?->code ?? '-' }}"     icon="o-building-library"  color="text-secondary" />
            <x-stat title="Program"    value="{{ $program->abbrev ?? '-' }}"                     icon="o-tag"               color="text-accent" />
        </div>

        <x-card title="Assigned Program" shadow separator>
            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                <x-input label="Program Name" value="{{ $program->name }}"                       readonly />
                <x-input label="Code"         value="{{ $program->code }}"                       readonly />
                <x-input label="Abbreviation" value="{{ $program->abbrev }}"                     readonly />
                <x-input label="Faculty"      value="{{ $program->client?->faculty?->name }}"    readonly />
            </div>
        </x-card>

        <div class="mt-6">
            <x-button label="View Timetable" icon="o-calendar-days" class="btn-primary"
                      link="{{ route('operator.timetable') }}" />
        </div>
    @else
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            This operator account has no program assigned. Please contact your administrator.
        </x-alert>
    @endif
</div>
