<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use WithPagination, Toast;

    public string $search     = '';
    public bool   $loginModal = false;
    public ?int   $loginId    = null;

    public array $headers = [
        ['key' => 'abbrev',       'label' => 'Kode',    'class' => 'w-1/12'],
        ['key' => 'name',         'label' => 'Nama',    'class' => 'w-4/12'],
        ['key' => 'user_email',   'label' => 'Email',   'class' => 'w-3/12'],
        ['key' => 'cluster_name', 'label' => 'Cluster', 'class' => 'w-2/12'],
        ['key' => 'action',       'label' => '',        'class' => 'w-2/12 text-right'],
    ];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function updatedSearch(): void { $this->resetPage(); }

    public function openCreate(): void { $this->dispatch('open-program-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-program-edit', id: $id); }

    public function confirmLoginAs(int $id): void { $this->loginId = $id; $this->loginModal = true; }

    public function loginAs(): mixed
    {
        $program = Program::with('user')->findOrFail($this->loginId);
        auth()->login($program->user);
        session()->save();
        return redirect()->route('program.idx');
    }

    #[On('program-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        $client = $this->client();
        return [
            'programs' => Program::with(['user', 'cluster.base'])
                    ->when($client, fn($q) => $q->where('client_id', $client->id), fn($q) => $q->whereRaw('0=1'))
                    ->when($this->search, fn($q) => $q
                        ->where('name', 'like', "%{$this->search}%")
                        ->orWhere('abbrev', 'like', "%{$this->search}%"))
                    ->paginate(6)
                    ->through(fn($p) => tap($p, fn($item) => [
                        $item->user_email   = $p->user?->email ?? '-',
                        $item->cluster_name = $p->cluster?->base?->code ?? '-',
                    ])),
        ];
    }
}; ?>

<div>
    <x-header title="Study Programs" subtitle="Manage study program data" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Add" icon="o-plus" wire:click="openCreate" class="btn-primary" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$programs" with-pagination container-class="overflow-hidden">
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil-square" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-arrow-right-on-rectangle" class="btn-ghost btn-sm btn-square"
                              wire:click="confirmLoginAs({{ $row->id }})" tooltip="Login as" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <x-modal wire:model="loginModal" title="Login as Program" box-class="!max-w-xs mx-auto">
        <p class="text-base-content/70 text-sm">Login as this study program? Your current session will be replaced.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle"                 wire:click="$set('loginModal', false)" />
            <x-button label="Login"  icon="o-arrow-right-on-rectangle" class="btn-primary" wire:click="loginAs" />
        </x-slot:actions>
    </x-modal>

    <livewire:pages::client.program.program-form-sheet />
</div>
