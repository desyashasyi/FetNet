<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\Specialization;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

/**
 * Specializations listing for the signed-in program: searchable, paginated table with
 * add/edit (via the form sheet) and delete. Deleting a specialization unlinks it from
 * its subjects (nulls their specialization_id). Hosts specialization-form-sheet.
 */
new #[Layout('layouts.program')] class extends Component
{
    use WithPagination, Toast;

    public string $search   = '';
    public bool   $delModal = false;
    public ?int   $deleteId = null;

    public array $headers = [
        ['key' => 'code',   'label' => 'Kode',      'class' => 'w-2/12'],
        ['key' => 'abbrev', 'label' => 'Singkatan', 'class' => 'w-2/12'],
        ['key' => 'name',   'label' => 'Nama',      'class' => 'w-6/12'],
        ['key' => 'action', 'label' => '',          'class' => 'w-2/12 text-right'],
    ];

    /** The signed-in user's program; scopes every query on this page. */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Reset pagination when the search term changes. */
    public function updatedSearch(): void { $this->resetPage(); }

    /** Open the form sheet for create / edit. */
    public function openCreate(): void { $this->dispatch('open-specialization-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-specialization-edit', id: $id); }

    /** Open the delete confirmation for one specialization. */
    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    /** Delete the confirmed specialization (unlinks its subjects). */
    public function delete(): void
    {
        Specialization::findOrFail($this->deleteId)->delete();
        $this->delModal = false; $this->deleteId = null;
        $this->warning('Specialization deleted.', position: 'toast-top toast-center');
    }

    /** Re-render after the form sheet saves. */
    #[On('specialization-changed')]
    public function refreshFromChild(): void {}

    /** Paginated specializations for this program, filtered by search. */
    public function with(): array
    {
        $program = $this->program();
        return [
            'specializations' => Specialization::when($program, fn($q) => $q->where('program_id', $program->id), fn($q) => $q->whereRaw('0=1'))
                    ->when($this->search, fn($q) => $q
                        ->where('name', 'like', "%{$this->search}%")
                        ->orWhere('code', 'like', "%{$this->search}%"))
                    ->orderBy('code')->paginate(6),
        ];
    }
}; ?>

<div>
    <x-header title="Specializations" subtitle="Manage study concentrations" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$specializations" with-pagination container-class="overflow-hidden">
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-trash" class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <livewire:pages::program.data.specialization.specialization-form-sheet />

    <x-modal wire:model="delModal" title="Delete Specialization" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this specialization? Subjects linked to it will be unlinked.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
