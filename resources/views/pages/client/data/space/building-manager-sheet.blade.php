<?php

use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal           = false;
    public ?int   $editBuildingId  = null;
    public string $buildingName    = '';
    public string $buildingCode    = '';
    public bool   $delModal        = false;
    public ?int   $deleteId        = null;

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function buildings()
    {
        $client = $this->client();
        return $client
            ? Building::where('client_id', $client->id)->orderBy('name')->get()
            : collect();
    }

    #[On('open-building-manager')]
    public function open(): void
    {
        $this->reset(['editBuildingId', 'buildingName', 'buildingCode']);
        $this->modal = true;
    }

    public function openEdit(int $id): void
    {
        $b = Building::findOrFail($id);
        $this->editBuildingId = $id;
        $this->buildingName   = $b->name;
        $this->buildingCode   = $b->code ?? '';
    }

    public function cancelEdit(): void
    {
        $this->reset(['editBuildingId', 'buildingName', 'buildingCode']);
    }

    public function save(): void
    {
        $this->validate([
            'buildingName' => 'required|max:200',
            'buildingCode' => 'nullable|max:20',
        ]);

        $client = $this->client();
        if (! $client) return;

        $data = [
            'client_id' => $client->id,
            'name'      => $this->buildingName,
            'code'      => trim($this->buildingCode) ?: null,
        ];

        if ($this->editBuildingId) {
            Building::findOrFail($this->editBuildingId)->update($data);
            $this->success('Building updated.', position: 'toast-top toast-center');
        } else {
            Building::create($data);
            $this->success('Building added.', position: 'toast-top toast-center');
        }

        $this->reset(['editBuildingId', 'buildingName', 'buildingCode']);
        unset($this->buildings);
        $this->dispatch('options-reload');
    }

    public function confirmDelete(int $id): void
    {
        $this->deleteId = $id;
        $this->delModal = true;
    }

    public function delete(): void
    {
        Building::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        unset($this->buildings);
        $this->warning('Building deleted.', position: 'toast-top toast-center');
        $this->dispatch('options-reload');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Manage Buildings"
             separator class="modal-bottom" box-class="!max-w-lg mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

            @if($this->buildings->isNotEmpty())
                <div class="divide-y divide-base-200">
                    @foreach($this->buildings as $b)
                        <div wire:key="bld-{{ $b->id }}" class="flex items-center justify-between py-2">
                            <div>
                                <span class="font-medium text-sm">{{ $b->name }}</span>
                                @if($b->code)
                                    <x-badge value="{{ $b->code }}" class="badge-neutral badge-xs ml-2" />
                                @endif
                            </div>
                            <div class="flex gap-1">
                                <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                          wire:click="openEdit({{ $b->id }})" />
                                <x-button icon="o-trash"  class="btn-ghost btn-xs btn-square text-error"
                                          wire:click="confirmDelete({{ $b->id }})" />
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <p class="text-sm text-base-content/40 text-center py-3">No buildings yet.</p>
            @endif

            <div class="border border-base-200 rounded-xl p-4 space-y-3">
                <p class="text-sm font-semibold text-base-content/70">
                    {{ $editBuildingId ? 'Edit Building' : 'Add Building' }}
                </p>
                <div class="grid grid-cols-3 gap-3">
                    <div class="col-span-2">
                        <x-input label="Name" wire:model="buildingName" placeholder="Gedung A" />
                    </div>
                    <x-input label="Code" wire:model="buildingCode" placeholder="GDA" />
                </div>
                <div class="flex gap-2">
                    @if($editBuildingId)
                        <x-button label="Cancel Edit" icon="o-x-mark" class="btn-ghost btn-sm" wire:click="cancelEdit" />
                    @endif
                    <x-button :label="$editBuildingId ? 'Update' : 'Add Building'"
                              icon="{{ $editBuildingId ? 'o-check' : 'o-plus' }}"
                              class="btn-primary btn-sm"
                              wire:click="save" />
                </div>
            </div>
        </div>
    </x-modal>

    <x-modal wire:model="delModal" title="Delete Building" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this building? Spaces assigned to it will have their building cleared.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
