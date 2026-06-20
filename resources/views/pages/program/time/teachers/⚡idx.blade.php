<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\Client;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use App\Models\FetNet\TeacherConstraint;
use App\Models\FetNet\TeacherTimeConstraint;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Teacher time-constraints page: pick a target (one teacher / all teachers) and a
 * constraint type (not-available slots, or a numeric/tag rule) and manage the
 * TeacherConstraint / TeacherTimeConstraint rows for the program. Candidate teachers span
 * the cluster plus this program's guests. Renders the shared numeric / not-available
 * summaries and hosts the shared constraint sheet. Uses HasProgramSemester.
 */
new #[Layout('layouts.program')] class extends Component
{
    use Toast, HasProgramSemester;

    public ?string $constraintType = null;
    public string  $target         = 'teacher';
    /** Teacher-name search for the not-available table (lives in the filter row). */
    public string  $teacherSearch  = '';

    // ── Helpers ───────────────────────────────────────────────────────────────

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

    /** Teachers across this program's cluster (or just its own if unclustered). */
    private function clusterTeachers(): \Illuminate\Support\Collection
    {
        $program = $this->program();
        if (! $program) return collect();

        $cluster = Cluster::where('program_id', $program->id)->first();
        if (! $cluster) {
            return Teacher::where('program_id', $program->id)->orderBy('name')->get();
        }

        $ids = Cluster::where('cluster_base_id', $cluster->cluster_base_id)->pluck('program_id');
        return Teacher::whereIn('program_id', $ids)->orderBy('name')->get();
    }

    /** This program's guest teachers (borrowed from other programs). */
    private function guestTeachers(): \Illuminate\Support\Collection
    {
        $program = $this->program();
        if (! $program) return collect();
        return $program->guestTeachers()->orderBy('name')->get();
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    /** Seed the academic-year/semester context for the program's client. */
    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    /** "All teachers" can't have not-available slots — reset the type if so. */
    public function updatedTarget(): void
    {
        if ($this->target === 'all' && $this->constraintType === 'not_available') {
            $this->constraintType = null;
        }
    }

    /** Open the constraint sheet to add a numeric/tag constraint. */
    public function openAddConstraint(): void
    {
        $this->dispatch('open-constraint-add');
    }

    /** Delete a numeric constraint by id (from the summary row). */
    #[On('constraint-delete-requested')]
    public function deleteConstraintById(int $id): void
    {
        TeacherConstraint::find($id)?->delete();
        $this->warning('Constraint removed.', position: 'toast-top toast-center');
    }

    /** Clear a teacher's not-available slots and the matching weight row. */
    public function clearNotAvailable(int $teacherId): void
    {
        TeacherTimeConstraint::where('teacher_id', $teacherId)->delete();
        TeacherConstraint::where('teacher_id', $teacherId)
            ->where('constraint_type', 'not_available')->delete();
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
    }

    /** Re-render after the constraint sheet saves. */
    #[On('constraint-changed')]
    public function refreshFromChild(): void
    {
        // empty: presence triggers re-render after child save
    }

    // ── with() ────────────────────────────────────────────────────────────────

    /**
     * View data: config layout plus, for the chosen constraint type, either numeric/tag
     * constraint rows or per-teacher not-available summaries (blocked maps + weights),
     * over the cluster + guest teacher set.
     */
    public function with(): array
    {
        $config  = $this->config();
        $cluster = $this->clusterTeachers();
        $guests  = $this->guestTeachers();
        $program = $this->program();

        $allTeachers = $cluster->merge($guests)->keyBy('id');

        $constraintRows = [];
        if ($program && $this->constraintType && $this->constraintType !== 'not_available') {
            $tagMap = ActivityTag::where('program_id', $program->id)->get()
                ->mapWithKeys(fn($t) => [$t->id => ['name' => $t->name]]);

            $rows = TeacherConstraint::where('program_id', $program->id)
                ->where('constraint_type', $this->constraintType)->get();

            $constraintRows = $rows->map(function ($row) use ($allTeachers, $tagMap) {
                $teacher  = $row->teacher_id ? $allTeachers->get($row->teacher_id) : null;
                $tag      = $row->tag_id  ? ($tagMap->get($row->tag_id)['name']  ?? '?') : null;
                $tag2     = $row->tag2_id ? ($tagMap->get($row->tag2_id)['name'] ?? '?') : null;
                $interval = ($row->interval_start && $row->interval_end)
                    ? "slot {$row->interval_start}–{$row->interval_end}" : null;

                return [
                    'id'           => $row->id,
                    'teacher'      => $teacher ? "[{$teacher->code}] {$teacher->name}" : '(All teachers)',
                    'params'       => collect([$tag, $tag2, $interval])->filter()->implode(', '),
                    'value'        => $row->value,
                    'weight'       => $row->weight,
                    'program_name' => null,
                ];
            })->values()->toArray();
        }

        $notAvailableRows = [];
        if ($program && $this->constraintType === 'not_available') {
            $blockedAll = TeacherTimeConstraint::whereIn('teacher_id', $allTeachers->keys())
                ->get()->groupBy('teacher_id');

            $weights = TeacherConstraint::where('program_id', $program->id)
                ->where('constraint_type', 'not_available')
                ->whereNotNull('teacher_id')
                ->get()->keyBy('teacher_id');

            $notAvailableRows = $allTeachers->map(fn($t) => [
                'id'           => $t->id,
                'teacher'      => "[{$t->code}] {$t->name}",
                'slots'        => $blockedAll->get($t->id, collect())->count(),
                'blockedMap'   => $blockedAll->get($t->id, collect())
                    ->mapWithKeys(fn($c) => ["{$c->day}-{$c->hour}" => true])->toArray(),
                'weight'       => isset($weights[$t->id]) ? (float) $weights[$t->id]->weight : 100.0,
                'program_name' => null,
            ])->values()->toArray();
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
    <x-header title="Teacher Time Constraints" separator />

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
                   :options="[['id'=>'teacher','name'=>'A teacher'],['id'=>'all','name'=>'All teachers']]"
                   class="w-36" />
        <select wire:model.live="constraintType" class="select select-bordered text-sm w-72">
            <option value="">Select constraint</option>

            @if($target === 'teacher')
            <optgroup label="─── Availability ───">
                <option value="not_available">Not Available Times</option>
            </optgroup>
            @endif

            <optgroup label="─── Days ───">
                <option value="max_days_per_week">Max Days per Week</option>
                <option value="min_days_per_week">Min Days per Week</option>
                <option value="hourly_interval_max_days">Working in Hourly Interval Max Days per Week</option>
            </optgroup>

            <optgroup label="─── Daily Hours ───">
                <option value="max_hours_daily">Max Hours Daily</option>
                <option value="min_hours_daily">Min Hours Daily</option>
                <option value="max_hours_daily_tag">Max Hours Daily with Activity Tag</option>
                <option value="min_hours_daily_tag">Min Hours Daily with Activity Tag</option>
                <option value="max_span_per_day">Max Span per Day</option>
            </optgroup>

            <optgroup label="─── Continuous ───">
                <option value="max_hours_continuously">Max Hours Continuously</option>
                <option value="max_hours_continuously_tag">Max Hours Continuously with Activity Tag</option>
            </optgroup>

            <optgroup label="─── Gaps & Rest ───">
                <option value="max_gaps_per_week">Max Gaps per Week</option>
                <option value="max_gaps_per_day">Max Gaps per Day</option>
                <option value="min_gaps_between_activity_tags">Min Gaps Between Activity Tags</option>
                <option value="min_resting_hours">Min Resting Hours</option>
            </optgroup>
        </select>
        @if($constraintType && $constraintType !== 'not_available')
            <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openAddConstraint" />
        @endif
        @if($constraintType === 'not_available')
            <x-input placeholder="Search teacher..." wire:model.live.debounce="teacherSearch"
                     icon="o-magnifying-glass" clearable class="w-56" />
        @endif
    </div>

    @if($numberOfDays === 0 || $numberOfHours === 0)
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            Days per week and slots per day have not been configured.
            Go to <strong>Admin → Data → Basic</strong> first.
        </x-alert>
    @elseif($constraintType)

        @if($constraintType !== 'not_available')
            <livewire:pages::shared.time-teacher-numeric-summary
                :key="'numeric-'.$constraintType.'-'.$programId"
                :rows="$constraintRows"
                :show-program-col="false"
                :can-add="true" />
        @endif

        @if($constraintType === 'not_available')
            <livewire:pages::shared.time-teacher-not-available-summary
                :key="'na-'.$programId"
                :rows="$notAvailableRows"
                :day-labels="$dayLabels"
                :slot-labels="$slotLabels"
                :number-of-days="$numberOfDays"
                :search="$teacherSearch"
                :show-program-col="false"
                :can-edit="true" />
        @endif

    @endif

    <livewire:pages::shared.time-teacher-constraint-sheet
        :key="'tsheet-'.$programId"
        :program-id="$programId"
        :constraint-type="$constraintType"
        :target="$target" />
</div>
