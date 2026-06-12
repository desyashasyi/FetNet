<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\SubjectType;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal    = false;
    public ?int   $editId   = null;
    public string $typeCode = '';
    public string $typeName = '';

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function types(): array
    {
        $program = $this->program();
        if (! $program) return [];
        return SubjectType::where('program_id', $program->id)
            ->orderBy('code')->get()
            ->map(fn($t) => ['id' => $t->id, 'code' => $t->code, 'name' => $t->name])
            ->toArray();
    }

    #[On('open-subject-type-modal')]
    public function open(): void
    {
        $this->reset(['typeCode', 'typeName', 'editId']);
        $this->modal = true;
    }

    public function openEdit(int $id): void
    {
        $t = SubjectType::findOrFail($id);
        $this->editId   = $id;
        $this->typeCode = $t->code;
        $this->typeName = $t->name;
    }

    public function cancelEdit(): void
    {
        $this->reset(['typeCode', 'typeName', 'editId']);
    }

    public function save(): void
    {
        $unique = 'required|unique:fetnet_subject_type,code';
        if ($this->editId) $unique .= ',' . $this->editId;
        $this->validate(['typeCode' => $unique, 'typeName' => 'required']);

        if ($this->editId) {
            SubjectType::findOrFail($this->editId)->update(['code' => $this->typeCode, 'name' => $this->typeName]);
            $this->success('Subject type updated.', position: 'toast-top toast-center');
        } else {
            SubjectType::create(['program_id' => $this->program()->id, 'code' => $this->typeCode, 'name' => $this->typeName]);
            $this->success('Subject type added.', position: 'toast-top toast-center');
        }
        $this->reset(['typeCode', 'typeName', 'editId']);
        unset($this->types);
        $this->dispatch('refresh-subject-options');
    }

    public function delete(int $id): void
    {
        SubjectType::find($id)?->delete();
        unset($this->types);
        $this->dispatch('refresh-subject-options');
        $this->warning('Subject type removed.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Subject Types"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-3">
            <div class="divide-y divide-base-200">
                @forelse($this->types as $t)
                    <div wire:key="tp-{{ $t['id'] }}" class="flex items-center justify-between py-2 {{ $editId === $t['id'] ? 'bg-base-200/60 -mx-2 px-2 rounded' : '' }}">
                        <div class="text-sm">
                            <span class="font-medium">{{ $t['code'] }}</span>
                            @if($t['name'])<span class="text-base-content/30 mx-1">|</span><span class="text-base-content/50">{{ $t['name'] }}</span>@endif
                        </div>
                        <div class="flex gap-1">
                            <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square" wire:click="openEdit({{ $t['id'] }})" />
                            <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                      wire:click="delete({{ $t['id'] }})"
                                      wire:confirm="Delete this subject type?" />
                        </div>
                    </div>
                @empty
                    <p class="text-xs text-base-content/40 italic py-2">No subject types yet.</p>
                @endforelse
            </div>

            <div class="divider my-1"></div>

            <x-form wire:submit="save" class="space-y-3">
                @if($editId)<p class="text-xs text-primary font-medium">Editing — <button type="button" wire:click="cancelEdit" class="underline">cancel</button></p>@endif
                <div class="flex gap-2 items-end">
                    <x-input label="Code" wire:model="typeCode" placeholder="MK" class="w-20" required />
                    <div class="flex-1"><x-input label="Type Name" wire:model="typeName" placeholder="Mata Kuliah Wajib" required /></div>
                    <x-button :icon="$editId ? 'o-check' : 'o-plus'" type="submit" class="btn-primary btn-sm mb-0.5" spinner="save" />
                </div>
            </x-form>
        </div>
        <x-slot:actions><x-button label="Done" icon="o-check" class="btn-primary" wire:click="$set('modal', false)" /></x-slot:actions>
    </x-modal>
</div>
