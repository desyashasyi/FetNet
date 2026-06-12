<?php

use App\Models\FetNet\Client;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.super-admin')] class extends Component
{
    use WithPagination, Toast;

    public string $search     = '';
    public bool   $loginModal = false;
    public ?int   $loginId    = null;

    public array $headers = [
        ['key' => 'user_name',  'label' => 'Username', 'class' => 'w-2/12 max-w-0 truncate'],
        ['key' => 'user_email', 'label' => 'Email',    'class' => 'w-3/12 max-w-0 truncate'],
        ['key' => 'university', 'label' => 'Univ',     'class' => 'w-1/12'],
        ['key' => 'faculty',    'label' => 'Faculty',  'class' => 'w-1/12'],
        ['key' => 'level',      'label' => 'Level',    'class' => 'w-1/12'],
        ['key' => 'action',     'label' => '',         'class' => 'w-2/12 text-right'],
    ];

    public function updatedSearch(): void { $this->resetPage(); }

    public function openCreate(): void { $this->dispatch('open-client-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-client-edit', id: $id); }

    public function confirmLoginAs(int $id): void
    {
        $this->loginId    = $id;
        $this->loginModal = true;
    }

    public function loginAs(): mixed
    {
        $client = Client::with('user')->findOrFail($this->loginId);
        session(['impersonator_id' => auth()->id()]);
        auth()->login($client->user);
        session()->save();
        return redirect()->route('client.idx');
    }

    #[On('client-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        return [
            'clients' => Client::with(['user', 'university', 'faculty', 'level'])
                ->when($this->search, fn($q) => $q->whereHas('user',
                    fn($u) => $u->where('name', 'like', "%{$this->search}%")
                ))
                ->paginate(6)
                ->through(fn($c) => tap($c, fn($item) => [
                    $item->user_name  = $c->user?->name ?? '-',
                    $item->user_email = $c->user?->email ?? '-',
                    $item->university = $c->university?->code ?? '-',
                    $item->faculty    = $c->faculty?->code ?? '-',
                    $item->level      = $c->level?->code ?? '-',
                ])),
        ];
    }
}; ?>

<div>
    <x-header title="Clients" subtitle="Manage FetNet clients" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search username..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Add Client" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$clients" with-pagination class="table-fixed" container-class="overflow-hidden">
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil-square" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-arrow-right-on-rectangle" class="btn-ghost btn-sm btn-square"
                              wire:click="confirmLoginAs({{ $row->id }})" tooltip="Login as client" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <x-modal wire:model="loginModal" title="Login as Client" box-class="!max-w-xs mx-auto">
        <p class="text-base-content/70 text-sm">Login as this client? Your current session will be replaced.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle"                 wire:click="$set('loginModal', false)" />
            <x-button label="Login"  icon="o-arrow-right-on-rectangle" class="btn-primary" wire:click="loginAs" />
        </x-slot:actions>
    </x-modal>

    <livewire:pages::super-admin.client.client-form-sheet />
</div>
