<?php

use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\CurriculumYear;
use App\Models\FetNet\Program;
use App\Models\FetNet\Subject;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Bottom-slide "Subject Planning" modal on /program/data/activities. Lets the user
 * mark which subjects are planned (have an ActivityPlanning row) for the active
 * program + semester. Supports search, curriculum-year/semester filters, paged
 * listing, per-subject toggle, and bulk "Plan All Odd/Even".
 *
 * Reactive on the parent's programId + semesterId. Toggling does NOT notify the
 * parent immediately; changes are batched and a single 'planning-changed' event is
 * dispatched on Done (see closePlanning + planDirty) so the parent re-render cannot
 * morph this native <dialog> shut mid-session.
 */
new class extends Component
{
    use Toast;

    #[Reactive] public ?int $programId  = null;
    #[Reactive] public ?int $semesterId = null;

    public bool   $modal              = false;
    public bool   $planDirty          = false;
    public string $planSearch         = '';
    public ?int   $planFilterYear     = null;
    public ?int   $planFilterSemester = null;
    public array $planSubjects       = [];
    public int   $planPage           = 1;
    public int   $planTotal          = 0;
    public int   $planPerPage        = 10;

    public array $subjectSemesterOptions = [
        ['id' => 1, 'name' => '1'], ['id' => 2, 'name' => '2'],
        ['id' => 3, 'name' => '3'], ['id' => 4, 'name' => '4'],
        ['id' => 5, 'name' => '5'], ['id' => 6, 'name' => '6'],
        ['id' => 7, 'name' => '7'], ['id' => 8, 'name' => '8'],
    ];

    /** Curriculum-year filter options for the active program, newest year first. */
    #[Computed]
    public function curriculumYearOptions(): array
    {
        if (! $this->programId) return [];
        return CurriculumYear::where('program_id', $this->programId)
            ->orderByDesc('year')->get()
            ->map(fn($y) => ['id' => $y->id, 'name' => $y->year])->toArray();
    }

    /** Open the modal: clear search/filters/dirty flag, reset to page 1, load list. */
    #[On('open-planning')]
    public function open(): void
    {
        $this->reset(['planSearch', 'planFilterYear', 'planFilterSemester', 'planDirty']);
        $this->planPage = 1;
        $this->loadPlanSubjects();
        $this->modal = true;
    }

    /**
     * Close the modal and, only if any planning changed this session, emit a single
     * 'planning-changed' so the parent refreshes once (avoids per-toggle re-renders
     * that would close the dialog).
     */
    public function closePlanning(): void
    {
        $this->modal = false;
        if ($this->planDirty) {
            $this->dispatch('planning-changed');
            $this->planDirty = false;
        }
    }

    /**
     * Load the current page of subjects for the active program, honouring the search
     * text + curriculum-year + semester filters, and flag each row 'planned' if an
     * ActivityPlanning row already exists for it in this program + semester.
     */
    public function loadPlanSubjects(): void
    {
        if (! $this->programId || ! $this->semesterId) { return; }

        $all = Subject::where('program_id', $this->programId)
            ->when($this->planFilterYear,     fn($q) => $q->where('curriculum_year_id', $this->planFilterYear))
            ->when($this->planFilterSemester, fn($q) => $q->where('semester', $this->planFilterSemester))
            ->when(trim($this->planSearch) !== '', fn($q) => $q->where(
                fn($w) => $w->where('name', 'like', '%'.trim($this->planSearch).'%')
                            ->orWhere('code', 'like', '%'.trim($this->planSearch).'%')
            ))
            ->orderBy('semester')->orderBy('code')->get();

        $this->planTotal = $all->count();

        $this->planSubjects = $all
            ->slice(($this->planPage - 1) * $this->planPerPage, $this->planPerPage)
            ->map(fn($s) => [
                'id'       => $s->id,
                'code'     => $s->code,
                'name'     => $s->name,
                'credit'   => $s->credit,
                'semester' => $s->semester,
                'planned'  => ActivityPlanning::where('subject_id', $s->id)
                    ->where('program_id', $this->programId)
                    ->where('semester_id', $this->semesterId)
                    ->exists(),
            ])->values()->toArray();
    }

    /** Search/filter changes reset to page 1 and reload the list. */
    public function updatedPlanSearch(): void          { $this->planPage = 1; $this->loadPlanSubjects(); }
    public function updatedPlanFilterYear(): void     { $this->planPage = 1; $this->loadPlanSubjects(); }
    public function updatedPlanFilterSemester(): void { $this->planPage = 1; $this->loadPlanSubjects(); }

    /** Manual pager (no WithPagination here since the list is built in-memory). */
    public function planPrevPage(): void { if ($this->planPage > 1) { $this->planPage--; $this->loadPlanSubjects(); } }
    public function planNextPage(): void { if ($this->planPage < ceil($this->planTotal / $this->planPerPage)) { $this->planPage++; $this->loadPlanSubjects(); } }

    /**
     * Toggle one subject's planned state for this program + semester. Uses withTrashed
     * so a previously-removed plan is restored rather than duplicated; a fresh subject
     * gets a new ActivityPlanning. Marks the session dirty and reloads. Restoring a
     * planning cascades-restore its activities (model deleting/restoring hooks).
     */
    public function togglePlanning(int $subjectId): void
    {
        if (! $this->programId || ! $this->semesterId) return;

        $existing = ActivityPlanning::withTrashed()
            ->where('subject_id', $subjectId)
            ->where('program_id', $this->programId)
            ->where('semester_id', $this->semesterId)
            ->first();

        if ($existing && ! $existing->trashed()) {
            $existing->delete();
        } elseif ($existing && $existing->trashed()) {
            $existing->restore();
        } else {
            ActivityPlanning::create([
                'subject_id'  => $subjectId,
                'program_id'  => $this->programId,
                'semester_id' => $this->semesterId,
            ]);
        }

        $this->planDirty = true;
        $this->loadPlanSubjects();
    }

    /**
     * Bulk-plan every subject of the given parity ('odd'|'even') for this program +
     * semester, optionally narrowed to the selected curriculum year. firstOrCreate +
     * restore makes it idempotent (won't duplicate or skip soft-deleted plans).
     */
    private function planAll(string $parity): void
    {
        if (! $this->programId || ! $this->semesterId) return;
        $modulo = $parity === 'odd' ? 1 : 0;

        Subject::where('program_id', $this->programId)
            ->whereNotNull('semester')
            ->whereRaw('semester % 2 = ?', [$modulo])
            ->when($this->planFilterYear, fn($q) => $q->where('curriculum_year_id', $this->planFilterYear))
            ->pluck('id')
            ->each(function ($id) {
                $record = ActivityPlanning::withTrashed()->firstOrCreate(
                    ['subject_id' => $id, 'program_id' => $this->programId, 'semester_id' => $this->semesterId]
                );
                if ($record->trashed()) $record->restore();
            });

        $this->planDirty = true;
        $this->loadPlanSubjects();
    }

    /** Plan all odd-semester / all even-semester subjects (bulk shortcuts). */
    public function planAllOdd(): void  { $this->planAll('odd'); }
    public function planAllEven(): void { $this->planAll('even'); }
}; ?>

<div>
    <x-modal wire:model="modal" title="Subject Planning" persistent
             separator class="modal-bottom" box-class="!max-w-3xl mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

            @if(! $semesterId)
                <x-alert title="Select a semester first" icon="o-exclamation-triangle" class="alert-warning" />
            @else
                <div class="flex flex-wrap items-end gap-3">
                    <x-input wire:model.live.debounce.300ms="planSearch" placeholder="Search subject..."
                             icon="o-magnifying-glass" clearable class="w-56" />
                    <x-select wire:model.live="planFilterYear"
                              :options="$this->curriculumYearOptions" placeholder="All Curricula" class="w-36" />
                    <x-select wire:model.live="planFilterSemester"
                              :options="$subjectSemesterOptions" placeholder="All Semesters" class="w-36" />
                    <x-button label="Plan All Odd"  icon="o-check" class="btn-sm btn-ghost"
                              wire:click="planAllOdd"  tooltip="Plan all odd-semester subjects" />
                    <x-button label="Plan All Even" icon="o-check" class="btn-sm btn-ghost"
                              wire:click="planAllEven" tooltip="Plan all even-semester subjects" />
                </div>

                <div class="divide-y divide-base-200">
                    @forelse($planSubjects as $s)
                        <div wire:key="plan-{{ $s['id'] }}"
                             class="flex items-center justify-between py-2 {{ $s['planned'] ? 'bg-primary/5' : '' }}">
                            <div class="flex-1 min-w-0">
                                <div class="flex items-center gap-2">
                                    @if($s['semester'])
                                        <span class="text-xs text-base-content/40 w-4 text-center shrink-0">{{ $s['semester'] }}</span>
                                    @endif
                                    <span class="font-mono text-xs text-base-content/60 shrink-0">{{ $s['code'] }}</span>
                                    <span class="text-sm truncate">{{ $s['name'] }}</span>
                                    <span class="text-xs text-base-content/30 shrink-0">{{ $s['credit'] }} SKS</span>
                                </div>
                            </div>
                            <x-button
                                :icon="$s['planned'] ? 'o-check-circle' : 'o-plus-circle'"
                                :class="'btn-sm btn-square ' . ($s['planned'] ? 'btn-primary' : 'btn-ghost')"
                                wire:click="togglePlanning({{ $s['id'] }})"
                                :tooltip="$s['planned'] ? 'Remove from plan' : 'Add to plan'" />
                        </div>
                    @empty
                        <p class="text-center text-sm text-base-content/40 py-6 italic">No subjects found.</p>
                    @endforelse
                </div>

                @if($planTotal > $planPerPage)
                <div class="flex items-center justify-between pt-2">
                    <span class="text-xs text-base-content/40">{{ $planTotal }} subjects</span>
                    <div class="join">
                        <x-button class="btn-xs join-item" icon="o-chevron-left"
                                  wire:click="planPrevPage" :disabled="$planPage <= 1" />
                        <span class="join-item btn btn-xs btn-ghost pointer-events-none">
                            {{ $planPage }} / {{ max(1, (int) ceil($planTotal / $planPerPage)) }}
                        </span>
                        <x-button class="btn-xs join-item" icon="o-chevron-right"
                                  wire:click="planNextPage" :disabled="$planPage >= ceil($planTotal / $planPerPage)" />
                    </div>
                </div>
                @endif
            @endif
        </div>
        <x-slot:actions>
            <x-button label="Done" icon="o-check" class="btn-primary" wire:click="closePlanning" />
        </x-slot:actions>
    </x-modal>
</div>
