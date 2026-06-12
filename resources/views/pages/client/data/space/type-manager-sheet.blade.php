<?php

use App\Models\FetNet\SpaceType;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal        = false;
    public ?int   $editTypeId   = null;
    public string $typeName     = '';
    public string $typeCode     = '';
    public bool   $typeIsTheory = false;
    public bool   $delModal     = false;
    public ?int   $deleteId     = null;

    #[Computed]
    public function spaceTypes()
    {
        return SpaceType::orderBy('name')->get();
    }

    #[On('open-type-manager')]
    public function open(): void
    {
        $this->reset(['editTypeId', 'typeName', 'typeCode', 'typeIsTheory']);
        $this->modal = true;
    }

    public function openEdit(int $id): void
    {
        $t = SpaceType::findOrFail($id);
        $this->editTypeId   = $id;
        $this->typeName     = $t->name;
        $this->typeCode     = $t->code ?? '';
        $this->typeIsTheory = (bool) $t->is_theory;
    }

    public function cancelEdit(): void
    {
        $this->reset(['editTypeId', 'typeName', 'typeCode', 'typeIsTheory']);
    }

    public function save(): void
    {
        $this->validate([
            'typeName' => 'required|max:100',
            'typeCode' => 'nullable|max:10',
        ]);

        $data = [
            'name'      => $this->typeName,
            'code'      => strtoupper(trim($this->typeCode)) ?: null,
            'is_theory' => $this->typeIsTheory,
        ];

        if ($this->editTypeId) {
            SpaceType::findOrFail($this->editTypeId)->update($data);
            $this->success('Type updated.', position: 'toast-top toast-center');
        } else {
            SpaceType::create($data);
            $this->success('Type added.', position: 'toast-top toast-center');
        }

        $this->reset(['editTypeId', 'typeName', 'typeCode', 'typeIsTheory']);
        unset($this->spaceTypes);
        $this->dispatch('options-reload');
    }

    public function confirmDelete(int $id): void
    {
        $this->deleteId = $id;
        $this->delModal = true;
    }

    public function delete(): void
    {
        SpaceType::findOrFail($this->deleteId)->delete();
        $this->delModal = false;
        $this->deleteId = null;
        unset($this->spaceTypes);
        $this->warning('Type deleted.', position: 'toast-top toast-center');
        $this->dispatch('options-reload');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Manage Space Types"
             separator class="modal-bottom" box-class="!max-w-lg mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

            @if($this->spaceTypes->isNotEmpty())
                <div class="divide-y divide-base-200">
                    @foreach($this->spaceTypes as $t)
                        <div wire:key="typ-{{ $t->id }}" class="flex items-center justify-between py-2">
                            <div class="flex items-center gap-2">
                                <span class="font-medium text-sm">{{ $t->name }}</span>
                                @if($t->code)
                                    <x-badge value="{{ $t->code }}" class="badge-neutral badge-xs" />
                                @endif
                                @if($t->is_theory)
                                    <x-badge value="theory" class="badge-warning badge-xs badge-dash" />
                                @endif
                            </div>
                            <div class="flex gap-1">
                                <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                          wire:click="openEdit({{ $t->id }})" />
                                <x-button icon="o-trash"  class="btn-ghost btn-xs btn-square text-error"
                                          wire:click="confirmDelete({{ $t->id }})" />
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <p class="text-sm text-base-content/40 text-center py-3">No types yet.</p>
            @endif

            <div class="border border-base-200 rounded-xl p-4 space-y-3">
                <p class="text-sm font-semibold text-base-content/70">
                    {{ $editTypeId ? 'Edit Type' : 'Add Type' }}
                </p>
                <div class="grid grid-cols-3 gap-3">
                    <div class="col-span-2">
                        <x-input label="Name" wire:model="typeName" placeholder="Laboratory" />
                    </div>
                    <x-input label="Code" wire:model="typeCode" placeholder="LAB" />
                </div>
                <x-toggle label="Theory (not claimable by programs)" wire:model="typeIsTheory" class="toggle-warning" />
                <div class="flex gap-2">
                    @if($editTypeId)
                        <x-button label="Cancel Edit" icon="o-x-mark" class="btn-ghost btn-sm" wire:click="cancelEdit" />
                    @endif
                    <x-button :label="$editTypeId ? 'Update' : 'Add Type'"
                              icon="{{ $editTypeId ? 'o-check' : 'o-plus' }}"
                              class="btn-primary btn-sm"
                              wire:click="save" />
                </div>
            </div>
        </div>
    </x-modal>

    <x-modal wire:model="delModal" title="Delete Space Type" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this type? Spaces assigned to it will have their type cleared.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
