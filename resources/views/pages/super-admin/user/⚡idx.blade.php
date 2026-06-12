<?php

use App\Models\User;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.super-admin')] class extends Component
{
    use WithPagination, Toast;

    public string $search = '';

    public array $headers = [
        ['key' => 'name',        'label' => 'Name',   'class' => 'w-3/12 max-w-0 truncate'],
        ['key' => 'email',       'label' => 'Email',  'class' => 'w-3/12 max-w-0 truncate'],
        ['key' => 'sso',         'label' => 'SSO / NIP', 'class' => 'w-2/12 max-w-0 truncate'],
        ['key' => 'role_names',  'label' => 'Role',   'class' => 'w-1/12'],
        ['key' => 'client_name', 'label' => 'Client', 'class' => 'w-2/12 max-w-0 truncate'],
        ['key' => 'action',      'label' => '',       'class' => 'w-1/12 text-right'],
    ];

    public function updatedSearch(): void { $this->resetPage(); }

    public function openCreate(): void { $this->dispatch('open-user-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-user-edit', id: $id); }

    #[On('user-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        return [
            'users' => User::with(['roles', 'client.university'])
                ->when($this->search, fn($q) => $q
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('email', 'like', "%{$this->search}%")
                    ->orWhere('sso', 'like', "%{$this->search}%"))
                ->paginate(6)
                ->through(fn($u) => tap($u, fn($item) => [
                    $item->role_names  = $u->roles->pluck('name')->implode(', ') ?: '-',
                    $item->client_name = $u->client?->university?->name ?? '-',
                ])),
        ];
    }
}; ?>

<div>
    <x-header title="Users" subtitle="Manage system users" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="New User" icon="o-plus" class="btn-primary btn-sm" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$users" with-pagination class="table-fixed" container-class="overflow-hidden">
            @scope('cell_action', $row)
                <div class="flex justify-end">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <livewire:pages::super-admin.user.user-form-sheet />
</div>
