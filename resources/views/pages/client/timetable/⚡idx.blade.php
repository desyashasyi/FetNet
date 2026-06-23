<?php

use App\Events\FetNet\CompileFetRequestedEvent;
use App\Events\FetNet\SolveTimetableRequestedEvent;
use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\TimetableSlot;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use Toast, HasProgramSemester;

    public ?int $activeSolveCompileId = null;
    public bool $publishModal = false;
    public bool $unpublishModal = false;
    /** True from clicking "Compile FET" until FetCompiledEvent arrives — drives the progress bar. */
    public bool $compiling = false;

    public function mount(): void
    {
        $this->mountSemesterContext($this->client()?->id);
        $this->primeActiveSolve();
    }

    /** Listen for the compile-finished broadcast so the progress bar can resolve in place. */
    public function getListeners(): array
    {
        $cid = $this->clientId;
        if (! $cid) return [];
        return ['echo:fet-compile.' . $cid . ',.FetCompiledEvent' => 'onCompiled'];
    }

    /** Compile finished: stop the progress bar and refresh the derived state (Generate, etc.). */
    public function onCompiled(array $payload): void
    {
        $this->compiling = false;
        unset($this->lastSuccess, $this->hasPending, $this->hasSlots,
              $this->downloadResultUrl, $this->isPublished, $this->viewTimetableUrl);
        $this->primeActiveSolve();
    }

    /**
     * Poll fallback: if broadcast never arrived (Pusher down) but the compile job
     * already finished, clear the progress bar so it doesn't stay stuck forever.
     */
    public function syncCompileState(): void
    {
        if ($this->compiling && ! $this->hasPending) {
            $this->compiling = false;
            unset($this->lastSuccess, $this->hasPending, $this->hasSlots,
                  $this->downloadResultUrl, $this->isPublished, $this->viewTimetableUrl);
            $this->primeActiveSolve();
        }
    }

    /**
     * Solver finished (relayed from the solver-log card): refresh the derived result
     * actions so "View Timetable" / download / publish appear without a manual refresh.
     */
    #[On('solver-finished')]
    public function onSolverFinished(): void
    {
        unset($this->lastSuccess, $this->hasPending, $this->hasSlots,
              $this->downloadResultUrl, $this->isPublished, $this->viewTimetableUrl);
        $this->primeActiveSolve();
    }

    public function updatedSemesterId(): void
    {
        $this->primeActiveSolve();
    }

    private function primeActiveSolve(): void
    {
        $cid = $this->clientId;
        if (! $cid || ! $this->semesterId) { $this->activeSolveCompileId = null; return; }
        $row = FetCompile::where('client_id', $cid)
            ->where('semester_id', $this->semesterId)
            ->whereNotNull('solver_status')
            ->orderByDesc('id')->first();
        $this->activeSolveCompileId = $row?->id;
    }

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function clientId(): ?int
    {
        return $this->client()?->id;
    }

    #[Computed]
    public function lastSuccess(): ?FetCompile
    {
        $cid = $this->clientId;
        if (! $cid || ! $this->semesterId) return null;
        return FetCompile::where('client_id', $cid)
            ->where('semester_id', $this->semesterId)
            ->where('status', 'success')
            ->orderByDesc('id')->first();
    }

    #[Computed]
    public function hasPending(): bool
    {
        $cid = $this->clientId;
        if (! $cid || ! $this->semesterId) return false;
        return FetCompile::where('client_id', $cid)
            ->where('semester_id', $this->semesterId)
            ->where('status', 'pending')->exists();
    }

    public function compile(): void
    {
        $cid = $this->clientId;
        if (! $cid)               { $this->error('Client not found.', position: 'toast-top toast-center'); return; }
        if (! $this->semesterId)  { $this->warning('Pick a semester first.', position: 'toast-top toast-center'); return; }
        if ($this->hasPending)    { $this->info('A compile is already running for this semester.', position: 'toast-top toast-center'); return; }

        event(new CompileFetRequestedEvent($cid, $this->semesterId, auth()->id()));
        $this->compiling = true;
        $this->info('Compiling FET file…', position: 'toast-top toast-center');
    }

    public function generate(): void
    {
        $compile = $this->lastSuccess;
        if (! $compile) {
            $this->warning('Compile a FET file first.', position: 'toast-top toast-center');
            return;
        }
        if ($compile->solver_status === 'running' || $compile->solver_status === 'stopping') {
            $this->info('Solver already running for this compile.', position: 'toast-top toast-center');
            $this->dispatch('open-solver-log', compileId: $compile->id);
            return;
        }

        event(new SolveTimetableRequestedEvent($compile->id, auth()->id()));
        $this->activeSolveCompileId = $compile->id;
        $this->dispatch('open-solver-log', compileId: $compile->id);
    }

    public function openLog(int $compileId): void
    {
        $this->dispatch('open-solver-log', compileId: $compileId);
    }

    #[Computed]
    public function viewTimetableUrl(): ?string
    {
        if (! $this->hasSlots || ! $this->semesterId) return null;
        return route('client.timetable.view', ['sem' => $this->semesterId]);
    }

    #[Computed]
    public function hasSlots(): bool
    {
        $cid = $this->clientId;
        if (! $cid || ! $this->semesterId) return false;
        return TimetableSlot::where('client_id', $cid)
            ->where('semester_id', $this->semesterId)
            ->exists();
    }

    #[Computed]
    public function downloadResultUrl(): ?string
    {
        $c = $this->lastSuccess;
        return ($c && $c->solver_result_path)
            ? route('client.timetable.result', $c->id)
            : null;
    }

    #[Computed]
    public function isPublished(): bool
    {
        $c = $this->lastSuccess;
        return $c && $c->published_at !== null;
    }

    public function publish(): void
    {
        $c = $this->lastSuccess;
        if (! $c || $c->status !== 'success') { $this->publishModal = false; return; }
        if (! in_array($c->solver_status, ['success', 'stopped'], true)) {
            $this->publishModal = false;
            $this->warning('Generate a successful timetable first.', position: 'toast-top toast-center');
            return;
        }

        FetCompile::where('client_id', $c->client_id)
            ->where('semester_id', $c->semester_id)
            ->whereNotNull('published_at')
            ->update(['published_at' => null, 'published_by' => null]);

        $c->update([
            'published_at' => now(),
            'published_by' => auth()->id(),
        ]);
        unset($this->isPublished, $this->lastSuccess);
        $this->publishModal = false;
        $this->success('Timetable published. Programs can now view it.', position: 'toast-top toast-center');
    }

    public function unpublish(): void
    {
        $c = $this->lastSuccess;
        if (! $c) { $this->unpublishModal = false; return; }
        $c->update(['published_at' => null, 'published_by' => null]);
        unset($this->isPublished, $this->lastSuccess);
        $this->unpublishModal = false;
        $this->warning('Timetable unpublished.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-header title="Timetable" subtitle="Compile a FET file and run the timetable generator" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-choices single
                   wire:model.live="academicYearId"
                   :options="$academicYearOptions"
                   placeholder="Academic year"
                   class="w-max min-w-44" />
        <x-choices single
                   wire:model.live="semesterId"
                   :options="$semesterOptions"
                   placeholder="Semester"
                   class="w-max min-w-44" />

        <div class="grow"></div>

        <x-button label="Compile FET" icon="o-document-arrow-down"
                  class="btn-primary"
                  :disabled="$compiling || $this->hasPending"
                  wire:click="compile" spinner="compile" />

        <x-button label="Generate Timetable" icon="o-bolt"
                  class="btn-accent"
                  :disabled="! $this->lastSuccess"
                  tooltip="{{ $this->lastSuccess ? 'Run solver on the latest compiled file' : 'Compile a FET file first' }}"
                  wire:click="generate" />
    </div>

    {{-- Compile progress: indeterminate bar shown while a compile is pending; it resolves
         via FetCompiledEvent (broadcast) or syncCompileState poll (fallback when Pusher is down). --}}
    @if($compiling || $this->hasPending)
        <div wire:poll.2000ms="syncCompileState" class="mb-4 px-3 py-2.5 rounded-md bg-base-200">
            <div class="flex items-center gap-2 mb-1.5 text-sm font-medium text-base-content/70">
                <x-loading class="loading-spinner loading-xs text-primary" />
                Compiling FET file…
            </div>
            <progress class="progress progress-primary w-full"></progress>
        </div>
    @endif

    {{-- Result actions: only meaningful once a timetable has been generated --}}
    @if($this->hasSlots || $this->downloadResultUrl)
        <div class="flex flex-wrap items-center gap-2 mb-4 px-3 py-2 rounded-md bg-base-200">
            <x-icon name="o-table-cells" class="w-5 h-5 text-base-content/60" />
            <span class="text-sm font-medium">Generated Timetable</span>

            @if($this->isPublished)
                <x-badge value="published" class="badge-success badge-sm" />
            @elseif($this->hasSlots)
                <x-badge value="draft" class="badge-info badge-sm" />
            @endif

            <div class="grow"></div>

            @if($this->viewTimetableUrl)
                <a href="{{ $this->viewTimetableUrl }}" target="_blank" rel="noopener"
                   class="btn btn-sm">
                    <x-icon name="o-eye" class="w-4 h-4" />
                    View Timetable
                    <x-icon name="o-arrow-top-right-on-square" class="w-3 h-3" />
                </a>
            @else
                <x-button label="View Timetable" icon="o-eye" class="btn-sm" disabled />
            @endif

            @if($this->downloadResultUrl)
                <x-button label="Download FET" icon="o-arrow-down-tray"
                          class="btn-sm"
                          :link="$this->downloadResultUrl" external />
            @endif

            @if($this->isPublished)
                <x-button label="Unpublish" icon="o-eye-slash"
                          class="btn-warning btn-sm"
                          wire:click="$set('unpublishModal', true)" />
            @elseif($this->hasSlots)
                <x-button label="Publish to Programs" icon="o-paper-airplane"
                          class="btn-success btn-sm"
                          wire:click="$set('publishModal', true)" />
            @endif
        </div>
    @endif

    <livewire:pages::client.timetable.compile-history-card
        :client-id="$this->clientId"
        :semester-id="$semesterId" />

    <livewire:pages::client.timetable.solver-log-card />
    <livewire:pages::client.timetable.compile-errors-sheet />

    <x-modal wire:model="publishModal" title="Publish Timetable" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Publish this timetable so all programs can see it?</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('publishModal', false)" />
            <x-button label="Publish" icon="o-paper-airplane" class="btn-success" wire:click="publish" />
        </x-slot:actions>
    </x-modal>

    <x-modal wire:model="unpublishModal" title="Unpublish Timetable" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Hide this timetable from programs?</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('unpublishModal', false)" />
            <x-button label="Unpublish" icon="o-eye-slash" class="btn-warning" wire:click="unpublish" />
        </x-slot:actions>
    </x-modal>
</div>
