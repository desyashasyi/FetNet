<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\Specialization;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Create/edit sheet for a Specialization scoped to the signed-in program. Validates a
 * unique code, then emits 'specialization-changed' so the list refreshes.
 */
new class extends Component
{
    use Toast;

    public bool   $modal  = false;
    public ?int   $editId = null;
    public string $code   = '';
    public string $abbrev = '';
    public string $name   = '';

    /** The signed-in user's program (used as owner on create). */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Open the sheet for a new specialization (blank form). */
    #[On('open-specialization-create')]
    public function openCreate(): void
    {
        $this->reset(['code', 'abbrev', 'name', 'editId']);
        $this->modal = true;
    }

    /** Open the sheet prefilled from an existing specialization. */
    #[On('open-specialization-edit')]
    public function openEdit(int $id): void
    {
        $s            = Specialization::findOrFail($id);
        $this->editId = $id;
        $this->code   = $s->code;
        $this->abbrev = $s->abbrev ?? '';
        $this->name   = $s->name;
        $this->modal  = true;
    }

    /** Validation rules; code uniqueness ignores the current row when editing. */
    protected function rules(): array
    {
        $unique = 'required|unique:fetnet_specialization,code';
        if ($this->editId) $unique .= ',' . $this->editId;
        return [
            'code'   => $unique,
            'abbrev' => 'nullable',
            'name'   => 'required',
        ];
    }

    /** Validate and create/update the specialization, then emit 'specialization-changed'. */
    public function save(): void
    {
        $this->validate();
        $data = ['code' => $this->code, 'abbrev' => $this->abbrev, 'name' => $this->name];

        if ($this->editId) {
            Specialization::findOrFail($this->editId)->update($data);
            $this->success('Specialization updated.', position: 'toast-top toast-center');
        } else {
            Specialization::create(array_merge($data, ['program_id' => $this->program()->id]));
            $this->success('Specialization added.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('specialization-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Specialization' : 'Add Specialization'"
             separator class="modal-bottom" box-class="!max-w-lg mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="w-5/6">
                <x-input label="Name" wire:model="name" placeholder="Electrical Power Engineering" required />
            </div>
            <div class="grid grid-cols-3 gap-3">
                <x-input label="Code" wire:model="code" placeholder="EPE" required />
                <div class="col-span-2">
                    <x-input label="Abbreviation" wire:model="abbrev" placeholder="EP. Eng" />
                </div>
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
