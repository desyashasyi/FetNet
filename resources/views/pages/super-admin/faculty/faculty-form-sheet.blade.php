<?php

use App\Models\FetNet\Faculty;
use App\Models\FetNet\University;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Create/edit sheet for a Faculty (opened from the faculties listing). Validates a
 * unique code per university, then emits 'faculty-changed' so the list refreshes.
 */
new class extends Component
{
    use Toast;

    public bool   $modal         = false;
    public ?int   $editId        = null;
    public string $code          = '';
    public string $name          = '';
    public string $name_eng      = '';
    public ?int   $university_id = null;

    /** University picker options ("CODE | Name"). */
    #[Computed]
    public function universitiesOptions(): array
    {
        return University::orderBy('code')->get(['id', 'code', 'name'])
            ->map(fn($u) => ['id' => $u->id, 'name' => "{$u->code} | {$u->name}"])->toArray();
    }

    /** Validation rules; the code uniqueness ignores the current row when editing. */
    protected function rules(): array
    {
        $uniqueCode = 'required|unique:institution_faculty,code';
        if ($this->editId) $uniqueCode .= ',' . $this->editId;
        return [
            'code'          => $uniqueCode,
            'name'          => 'required',
            'name_eng'      => 'nullable',
            'university_id' => 'required|exists:institution_university,id',
        ];
    }

    /** Open the sheet for a new faculty (blank form). */
    #[On('open-faculty-create')]
    public function openCreate(): void
    {
        $this->reset(['code', 'name', 'name_eng', 'university_id', 'editId']);
        $this->modal = true;
    }

    /** Open the sheet prefilled from an existing faculty. */
    #[On('open-faculty-edit')]
    public function openEdit(int $id): void
    {
        $f = Faculty::findOrFail($id);
        $this->editId        = $id;
        $this->code          = $f->code;
        $this->name          = $f->name;
        $this->name_eng      = $f->name_eng ?? '';
        $this->university_id = $f->university_id;
        $this->modal         = true;
    }

    /** Validate and create/update the faculty, then emit 'faculty-changed'. */
    public function save(): void
    {
        $this->validate();
        $data = [
            'code'          => $this->code,
            'name'          => $this->name,
            'name_eng'      => $this->name_eng,
            'university_id' => $this->university_id,
        ];

        if ($this->editId) {
            Faculty::findOrFail($this->editId)->update($data);
        } else {
            Faculty::create($data);
        }

        $this->success($this->editId ? 'Faculty updated.' : 'Faculty added successfully.', position: 'toast-top toast-center');
        $this->modal = false;
        $this->dispatch('faculty-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Faculty' : 'Add Faculty'" separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="w-3/4">
                <x-choices label="University" single searchable wire:model="university_id" :options="$this->universitiesOptions" placeholder="Select university" required />
            </div>
            <div class="grid grid-cols-4 gap-3">
                <x-input label="Code" wire:model="code" placeholder="FPTEK" required />
                <div class="col-span-3">
                    <x-input label="Name" wire:model="name" placeholder="Faculty of Technology and Vocational Education" required />
                </div>
            </div>
            <div class="w-5/6">
                <x-input label="Name (EN)" wire:model="name_eng" placeholder="Faculty of Technology and Vocational Education" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
