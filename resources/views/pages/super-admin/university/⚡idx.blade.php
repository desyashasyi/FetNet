<?php

use App\Models\FetNet\University;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

/**
 * Super-admin Universities listing: searchable, paginated table with add/edit (via the
 * form sheet) and delete. Hosts university-form-sheet.
 */
new #[Layout('layouts.super-admin')] class extends Component
{
    use WithPagination, Toast;

    public string $search      = '';
    public bool   $deleteModal = false;
    public ?int   $deleteId    = null;

    public array $headers = [
        ['key' => 'code',     'label' => 'Kode',           'class' => 'w-1/12'],
        ['key' => 'name',     'label' => 'Nama',           'class' => 'w-5/12'],
        ['key' => 'name_eng', 'label' => 'Nama (Inggris)', 'class' => 'w-5/12'],
        ['key' => 'action',   'label' => '',               'class' => 'w-1/12 text-right'],
    ];

    /** Reset pagination when the search term changes. */
    public function updatedSearch(): void { $this->resetPage(); }

    /** Open the form sheet for create / edit. */
    public function openCreate(): void { $this->dispatch('open-university-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-university-edit', id: $id); }

    /** Open the delete confirmation for one university. */
    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->deleteModal = true; }

    /** Delete the confirmed university. */
    public function delete(): void
    {
        University::destroy($this->deleteId);
        $this->deleteModal = false; $this->deleteId = null;
        $this->warning('University deleted.', position: 'toast-top toast-center');
    }

    /** Re-render after the form sheet saves. */
    #[On('university-changed')]
    public function refreshFromChild(): void {}

    /** Paginated universities filtered by search. */
    public function with(): array
    {
        return [
            'universities' => University::query()
                ->when($this->search, fn($q) => $q
                    ->where('code', 'like', "%{$this->search}%")
                    ->orWhere('name', 'like', "%{$this->search}%"))
                ->paginate(6),
        ];
    }
}; ?>

<div>
    <x-header title="Universities" subtitle="Manage university data" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$universities" with-pagination container-class="overflow-hidden">
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <livewire:pages::super-admin.university.university-form-sheet />

    <x-modal wire:model="deleteModal" title="Delete University" box-class="!max-w-xs mx-auto">
        <p class="text-base-content/70 text-sm">Are you sure you want to delete this university?</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('deleteModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
