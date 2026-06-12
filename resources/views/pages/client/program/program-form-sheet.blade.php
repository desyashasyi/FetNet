<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\ClusterBase;
use App\Models\FetNet\Program;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal    = false;
    public string $mode     = 'create';
    public ?int   $editId   = null;

    public string $name           = '';
    public string $code           = '';
    public string $abbrev         = '';
    public string $email          = '';
    public string $password       = '';
    public ?int   $cluster_base_id = null;

    public bool   $clusterModal   = false;
    public string $clusterCode    = '';
    public string $clusterName    = '';
    public string $clusterNameEng = '';

    public array $clustersOptions = [];

    public function mount(): void { $this->loadClusters(); }

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    private function loadClusters(): void
    {
        $client = $this->client();
        $this->clustersOptions = $client
            ? ClusterBase::where('client_id', $client->id)->get(['id', 'code', 'name'])
                ->map(fn($c) => ['id' => $c->id, 'name' => "{$c->code} | {$c->name}"])->toArray()
            : [];
    }

    private function isClusterLevel(): bool
    {
        return $this->client()?->level?->code === 'CLU';
    }

    #[On('open-program-create')]
    public function openCreate(): void
    {
        $this->reset(['name', 'code', 'abbrev', 'email', 'password', 'cluster_base_id', 'editId']);
        $this->mode = 'create';
        if ($this->isClusterLevel()) {
            $this->cluster_base_id = $this->client()?->cluster?->id;
        }
        $this->loadClusters();
        $this->modal = true;
    }

    #[On('open-program-edit')]
    public function openEdit(int $id): void
    {
        $program               = Program::with(['user', 'cluster'])->findOrFail($id);
        $this->mode            = 'edit';
        $this->editId          = $id;
        $this->name            = $program->name;
        $this->code            = $program->code;
        $this->abbrev          = $program->abbrev;
        $this->email           = $program->user?->email ?? '';
        $this->cluster_base_id = $program->cluster?->cluster_base_id;
        $this->loadClusters();
        $this->modal = true;
    }

    public function save(): void
    {
        if ($this->mode === 'create') {
            $this->validate([
                'name'     => 'required|unique:institution_program,name',
                'code'     => 'required|unique:institution_program,code',
                'abbrev'   => 'required|unique:institution_program,abbrev',
                'email'    => 'required|email|unique:users,email',
                'password' => 'required|min:6',
            ]);

            $user = User::create([
                'name'     => $this->abbrev,
                'email'    => $this->email,
                'password' => Hash::make($this->password),
            ]);
            $user->assignRole('program');

            $program = Program::create([
                'name'      => $this->name,
                'code'      => $this->code,
                'abbrev'    => $this->abbrev,
                'client_id' => $this->client()->id,
                'user_id'   => $user->id,
            ]);

            if ($this->cluster_base_id) {
                Cluster::create([
                    'program_id'      => $program->id,
                    'cluster_base_id' => $this->cluster_base_id,
                ]);
            }

            $this->success('Program added successfully.', position: 'toast-top toast-center');
        } else {
            $this->validate([
                'name'  => 'required',
                'code'  => 'required',
                'email' => 'required|email',
            ]);

            $program = Program::findOrFail($this->editId);
            $program->update([
                'name'   => $this->name,
                'code'   => $this->code,
                'abbrev' => $this->abbrev,
            ]);
            $program->user?->update(['email' => $this->email]);

            if ($this->cluster_base_id) {
                Cluster::updateOrCreate(
                    ['program_id' => $this->editId],
                    ['cluster_base_id' => $this->cluster_base_id]
                );
            }

            $this->success('Program updated.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('program-changed');
    }

    public function openClusterModal(): void
    {
        $this->reset(['clusterCode', 'clusterName', 'clusterNameEng']);
        $this->clusterModal = true;
    }

    public function saveCluster(): void
    {
        $this->validate([
            'clusterCode' => 'required|max:10',
            'clusterName' => 'required|max:100',
        ]);

        $cluster = ClusterBase::create([
            'client_id' => $this->client()->id,
            'code'      => $this->clusterCode,
            'name'      => $this->clusterName,
            'name_eng'  => $this->clusterNameEng ?: null,
        ]);

        $this->loadClusters();
        $this->cluster_base_id = $cluster->id;
        $this->clusterModal = false;
        $this->success('Cluster created.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$mode === 'create' ? 'Add Study Program' : 'Edit Study Program'" separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <div class="w-5/6"><x-input label="Program Name" wire:model="name" required /></div>
            <div class="grid grid-cols-4 gap-3">
                <x-input label="Code" wire:model="code" required />
                <div class="col-span-2"><x-input label="Abbreviation" wire:model="abbrev" required /></div>
            </div>
            @if($mode === 'create')
                <div class="grid grid-cols-2 gap-3">
                    <x-input    label="Email"    wire:model="email"    type="email" required />
                    <x-password label="Password" wire:model="password" required />
                </div>
            @else
                <div class="w-3/4"><x-input label="Email" wire:model="email" type="email" required /></div>
            @endif
            <div class="flex items-end gap-2 w-3/4">
                <div class="flex-1">
                    <x-choices label="Cluster" single searchable wire:model="cluster_base_id"
                               :options="$clustersOptions" placeholder="-- Select Cluster --" />
                </div>
                <x-button icon="o-plus-circle" class="btn-ghost btn-square btn-sm mb-1"
                          wire:click="openClusterModal" tooltip="Create new cluster" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>

    <x-modal wire:model="clusterModal" title="Create Cluster" separator
             class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="saveCluster" class="space-y-3">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-input label="Code"      wire:model="clusterCode"    placeholder="e.g. CLU-A" required />
            <x-input label="Name"      wire:model="clusterName"    placeholder="Cluster name" required />
            <x-input label="Name (EN)" wire:model="clusterNameEng" placeholder="English name (optional)" />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('clusterModal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveCluster" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
