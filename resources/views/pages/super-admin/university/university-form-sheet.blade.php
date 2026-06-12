<?php

use App\Models\FetNet\University;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal    = false;
    public ?int   $editId   = null;
    public string $code     = '';
    public string $name     = '';
    public string $name_eng = '';

    protected function rules(): array
    {
        $uniqueCode = 'required|unique:institution_university,code';
        $uniqueName = 'required|unique:institution_university,name';
        if ($this->editId) {
            $uniqueCode .= ',' . $this->editId;
            $uniqueName .= ',' . $this->editId;
        }
        return [
            'code'     => $uniqueCode,
            'name'     => $uniqueName,
            'name_eng' => 'nullable',
        ];
    }

    #[On('open-university-create')]
    public function openCreate(): void
    {
        $this->reset(['code', 'name', 'name_eng', 'editId']);
        $this->modal = true;
    }

    #[On('open-university-edit')]
    public function openEdit(int $id): void
    {
        $u = University::findOrFail($id);
        $this->editId = $id;
        $this->code = $u->code;
        $this->name = $u->name;
        $this->name_eng = $u->name_eng ?? '';
        $this->modal = true;
    }

    public function save(): void
    {
        $this->validate();
        $data = ['code' => $this->code, 'name' => $this->name, 'name_eng' => $this->name_eng];
        if ($this->editId) {
            University::findOrFail($this->editId)->update($data);
        } else {
            University::create($data);
        }
        $this->success($this->editId ? 'University updated.' : 'University added successfully.', position: 'toast-top toast-center');
        $this->modal = false;
        $this->reset(['code', 'name', 'name_eng', 'editId']);
        $this->dispatch('university-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit University' : 'Add University'" separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <div class="grid grid-cols-4 gap-3">
                <x-input label="Code" wire:model="code" placeholder="UPI" required />
                <div class="col-span-3">
                    <x-input label="Name" wire:model="name" placeholder="Universitas Pendidikan Indonesia" required />
                </div>
            </div>
            <div class="w-5/6">
                <x-input label="Name (EN)" wire:model="name_eng" placeholder="Indonesia University of Education" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
