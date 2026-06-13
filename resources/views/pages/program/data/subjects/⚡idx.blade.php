<?php

use App\Models\FetNet\CurriculumYear;
use App\Models\FetNet\Program;
use App\Models\FetNet\Subject;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.program')] class extends Component
{
    use WithPagination, Toast;

    public string $search      = '';
    public ?int   $filterYear  = null;
    public bool   $delModal    = false;
    public bool   $delAllModal = false;
    public ?int   $deleteId    = null;

    public array $curriculumYearOptions = [];

    public array $headers = [
        ['key' => 'curriculum_yr',     'label' => 'Curriculum', 'class' => 'w-1/12 text-center'],
        ['key' => 'code',              'label' => 'Code',       'class' => 'w-1/12'],
        ['key' => 'name',              'label' => 'Name',       'class' => 'w-4/12'],
        ['key' => 'credit',            'label' => 'SKS',        'class' => 'w-1/12 text-center'],
        ['key' => 'semester',          'label' => 'Sem',        'class' => 'w-1/12 text-center'],
        ['key' => 'specialization_nm', 'label' => 'Specialize', 'class' => 'w-1/12'],
        ['key' => 'type_nm',           'label' => 'Type',       'class' => 'w-1/12'],
        ['key' => 'action',            'label' => '',           'class' => 'w-1/12 text-right'],
    ];

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    public function mount(): void { $this->loadYearOptions(); }

    private function loadYearOptions(): void
    {
        $program = $this->program();
        if (! $program) return;
        $this->curriculumYearOptions = CurriculumYear::where('program_id', $program->id)
            ->orderByDesc('year')->get()
            ->map(fn($y) => ['id' => $y->id, 'name' => $y->year])->toArray();
    }

    public function updatedSearch(): void { $this->resetPage(); }
    public function updatedFilterYear(): void { $this->resetPage(); }


    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    public function delete(): void
    {
        Subject::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        $this->warning('Subject deleted. Related activities also deleted.', position: 'toast-top toast-center');
    }

    public function confirmDeleteAll(): void { $this->delAllModal = true; }

    public function deleteAll(): void
    {
        $program = $this->program();
        if (! $program) { $this->delAllModal = false; return; }

        // Iterate per model so the deleting hook cascades to related activities.
        $count = 0;
        Subject::where('program_id', $program->id)
            ->chunkById(200, function ($subjects) use (&$count) {
                foreach ($subjects as $s) { $s->delete(); $count++; }
            });

        $this->delAllModal = false;
        $this->resetPage();
        $this->dispatch('subject-changed');
        $this->dispatch('refresh-subject-options');
        $this->warning("{$count} subjects deleted. Related activities also deleted.", position: 'toast-top toast-center');
    }

    #[On('subject-changed')]
    #[On('refresh-subject-options')]
    public function refreshFromChild(): void
    {
        $this->loadYearOptions();
    }

    #[On('curriculum-year-deleted')]
    public function unsetFilterYear(int $id): void
    {
        if ($this->filterYear === $id) $this->filterYear = null;
    }

    public function with(): array
    {
        $program = $this->program();
        return [
            'programId'    => $program?->id,
            'subjectCount' => $program ? Subject::where('program_id', $program->id)->count() : 0,
            'subjects' => Subject::with(['curriculumYear', 'specialization', 'type'])
                    ->when($program, fn($q) => $q->where('program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                    ->when($this->filterYear, fn($q) => $q->where('curriculum_year_id', $this->filterYear))
                    ->when($this->search, fn($q) => $q
                        ->where('name', 'like', "%{$this->search}%")
                        ->orWhere('code', 'like', "%{$this->search}%"))
                    ->orderBy('semester')->orderBy('code')
                    ->paginate(6)
                    ->through(fn($s) => tap($s, fn($item) => [
                        $item->curriculum_yr     = $s->curriculumYear?->year ?? '—',
                        $item->specialization_nm = $s->specialization?->code ?? '—',
                        $item->type_nm           = $s->type?->code ?? '—',
                    ])),
        ];
    }
}; ?>

<div>
    <x-header title="Subjects" subtitle="Manage course subjects" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-select wire:model.live="filterYear" :options="$curriculumYearOptions"
                  placeholder="All Curricula" class="w-40" />
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Curriculum"    icon="o-calendar"     class="btn-ghost btn-sm" wire:click="$dispatch('open-curriculum-year-modal')" />
        <x-button label="Specialization" icon="o-academic-cap" class="btn-ghost btn-sm" wire:click="$dispatch('open-specialization-modal')" />
        <x-button label="Types"  icon="o-tag"           class="btn-ghost btn-sm" wire:click="$dispatch('open-subject-type-modal')" />
        <x-button label="Import" icon="o-arrow-up-tray" class="btn-ghost btn-sm" wire:click="$dispatch('open-subject-import')" />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="$dispatch('open-subject-create')" />
        @if($subjectCount > 0)
            <x-button label="Delete All" icon="o-trash" class="btn-ghost btn-sm text-error" wire:click="confirmDeleteAll" />
        @endif
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$subjects" with-pagination container-class="overflow-hidden" class="table-fixed">
            @scope('cell_curriculum_yr', $row)
                <div class="text-center">@if($row->curriculum_yr !== '—'){{ $row->curriculum_yr }}@else<span class="text-base-content/20">—</span>@endif</div>
            @endscope
            @scope('cell_credit', $row)<div class="text-center">{{ $row->credit }}</div>@endscope
            @scope('cell_semester', $row)
                <div class="text-center">@if($row->semester){{ $row->semester }}@else<span class="text-base-content/20">—</span>@endif</div>
            @endscope
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square" wire:click="$dispatch('open-subject-edit', { id: {{ $row->id }} })" tooltip="Edit" />
                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error" wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <livewire:pages::program.data.subjects.subject-edit-sheet
        :program-id="$programId"
        :default-year-id="$filterYear" />

    <livewire:pages::program.data.subjects.curriculum-year-sheet />
    <livewire:pages::program.data.subjects.specialization-sheet />
    <livewire:pages::program.data.subjects.subject-type-sheet />
    <livewire:pages::program.data.subjects.import-sheet />

    <x-modal wire:model="delModal" title="Delete Subject" box-class="!max-w-xs">
        <p class="text-base-content/70 text-sm">Delete this subject? All related activities will also be deleted.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>

    <x-modal wire:model="delAllModal" title="Delete All Subjects" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">
            Delete all {{ $subjectCount }} subjects in this program? All related activities will also be deleted. This cannot be undone.
        </p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delAllModal', false)" />
            <x-button label="Delete All" icon="o-trash" class="btn-error" wire:click="deleteAll" spinner="deleteAll" />
        </x-slot:actions>
    </x-modal>
</div>
