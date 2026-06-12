<?php

use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceClaim;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use WithPagination, Toast;

    public string $search           = '';
    public bool   $delModal         = false;
    public ?int   $deleteId         = null;
    public ?int   $filterBuildingId = null;
    public array  $sortBy           = ['column' => 'name', 'direction' => 'asc'];
    public array  $buildingOptions  = [];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function mount(): void { $this->loadBuildingOptions(); }

    #[On('space-changed')]
    public function refresh(): void { $this->loadBuildingOptions(); }

    private function loadBuildingOptions(): void
    {
        $client = $this->client();
        if (! $client) return;
        $this->buildingOptions = Building::where('client_id', $client->id)
            ->orderByRaw('name REGEXP "^[A-Za-z]" DESC, name')
            ->limit(30)->get(['id', 'name'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->name])->toArray();
    }

    public function searchBuildings(string $value = ''): void
    {
        $client = $this->client();
        if (! $client) { $this->buildingOptions = []; return; }
        $this->buildingOptions = Building::where('client_id', $client->id)
            ->where(fn($q) => $q
                ->where('name', 'like', "%{$value}%")
                ->orWhere('code', 'like', "%{$value}%"))
            ->orderByRaw('name REGEXP "^[A-Za-z]" DESC, name')
            ->limit(30)->get(['id', 'name'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->name])->toArray();
    }

    public function updatedSearch(): void { $this->resetPage(); }
    public function updatedFilterBuildingId(): void { $this->resetPage(); }

    public function sortBy(array $sortBy): void
    {
        $this->sortBy = $sortBy;
        $this->resetPage();
    }

    public function openCreate(): void           { $this->dispatch('open-space-create'); }
    public function openEdit(int $id): void      { $this->dispatch('open-space-edit', id: $id); }
    public function openBuildingManager(): void  { $this->dispatch('open-building-manager'); }
    public function openTypeManager(): void      { $this->dispatch('open-type-manager'); }
    public function openImport(): void           { $this->dispatch('open-import'); }
    public function openClaims(): void           { $this->dispatch('open-claims'); }

    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    public function delete(): void
    {
        Space::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        $this->warning('Space deleted.', position: 'toast-top toast-center');
    }

    public function with(): array
    {
        $clientId = $this->client()?->id;

        $headers = [
            ['key' => 'code',           'label' => 'Code',     'class' => 'w-1/12'],
            ['key' => 'name',           'label' => 'Name',     'class' => 'w-3/12', 'sortable' => true],
            ['key' => 'type_label',     'label' => 'Type',     'class' => 'w-1/12', 'sortable' => true],
            ['key' => 'building_label', 'label' => 'Building', 'class' => 'w-2/12', 'sortable' => true],
            ['key' => 'floor',          'label' => 'Floor',    'class' => 'w-1/12 text-center'],
            ['key' => 'capacity',       'label' => 'Cap.',     'class' => 'w-1/12 text-center'],
            ['key' => 'action',         'label' => '',         'class' => 'w-2/12 text-right'],
        ];

        $spaces = $clientId
            ? Space::with(['type:id,name,code', 'building:id,name,code'])
                ->where('fetnet_space.client_id', $clientId)
                ->when($this->filterBuildingId, fn($q) => $q->where('building_id', $this->filterBuildingId))
                ->when($this->search, fn($q) => $q
                    ->where('fetnet_space.name', 'like', "%{$this->search}%")
                    ->orWhere('fetnet_space.code', 'like', "%{$this->search}%"))
                ->when($this->sortBy['column'] === 'name',           fn($q) => $q->orderBy('fetnet_space.name', $this->sortBy['direction']))
                ->when($this->sortBy['column'] === 'type_label',     fn($q) => $q->leftJoin('fetnet_space_type as st', 'fetnet_space.type_id', '=', 'st.id')->orderBy('st.name', $this->sortBy['direction'])->select('fetnet_space.*'))
                ->when($this->sortBy['column'] === 'building_label', fn($q) => $q->leftJoin('fetnet_building as fb', 'fetnet_space.building_id', '=', 'fb.id')->orderBy('fb.name', $this->sortBy['direction'])->select('fetnet_space.*'))
                ->when(! in_array($this->sortBy['column'], ['name', 'type_label', 'building_label']), fn($q) => $q->orderBy('fetnet_space.name'))
                ->paginate(6)
                ->through(fn($s) => tap($s, fn($item) => [
                    $item->type_label     = $s->type?->code ?? '—',
                    $item->building_label = $s->building?->name ?? '—',
                ]))
            : collect();

        $pendingClaimsCount = $clientId
            ? SpaceClaim::whereHas('space', fn($q) => $q->where('client_id', $clientId))
                ->where('status', 'pending')->count()
            : 0;

        return compact('headers', 'spaces', 'pendingClaimsCount');
    }
}; ?>

<div>
    <x-header title="Spaces / Rooms" subtitle="Manage rooms and spaces" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <div class="relative">
            <x-button icon="o-bell" class="btn-ghost btn-sm btn-square"
                      wire:click="openClaims" tooltip="Space Claim Requests" />
            @if($pendingClaimsCount > 0)
                <span class="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-warning text-warning-content text-[10px] font-bold pointer-events-none">
                    {{ $pendingClaimsCount }}
                </span>
            @endif
        </div>
        <x-choices single searchable clearable
                   wire:model.live="filterBuildingId"
                   :search-function="'searchBuildings'"
                   :options="$buildingOptions"
                   placeholder="— All Buildings —"
                   class="w-max min-w-48" />
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Types" icon="o-tag" class="btn-ghost btn-sm" wire:click="openTypeManager" />
        <x-button label="Buildings" icon="o-building-office-2" class="btn-ghost btn-sm" wire:click="openBuildingManager" />
        <x-button label="Import" icon="o-arrow-up-tray" class="btn-ghost btn-sm" wire:click="openImport" />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$spaces" with-pagination container-class="overflow-hidden"
                 :sort-by="$sortBy" wire:sort="sortBy">
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

    <x-modal wire:model="delModal" title="Delete Space" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this space/room?</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>

    <livewire:pages::client.data.space.space-edit-sheet />
    <livewire:pages::client.data.space.building-manager-sheet />
    <livewire:pages::client.data.space.type-manager-sheet />
    <livewire:pages::client.data.space.import-sheet />
    <livewire:pages::client.data.space.claims-sheet />
</div>
