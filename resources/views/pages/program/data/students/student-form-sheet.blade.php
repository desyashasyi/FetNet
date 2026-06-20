<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use Illuminate\Validation\Rule;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Form sheet for student hierarchy nodes. Two modals: a batch form (top-level, parent_id
 * null, with batch year + headcount) and a group form (group or sub-group under a parent,
 * with headcount). Both create/update Student rows for the program and emit
 * 'student-changed'.
 */
new class extends Component
{
    use Toast;

    // batch
    public bool   $batchModal = false;
    public bool   $editBatch  = false;
    public ?int   $batchId    = null;
    public string $batchName  = '';
    public string $batchBatch = '';
    public int    $batchCount = 0;

    // group
    public bool   $groupModal    = false;
    public bool   $editGroup     = false;
    public ?int   $groupId       = null;
    public ?int   $groupParentId = null;
    public string $groupName     = '';
    public int    $groupCount    = 0;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Open the batch modal for a new top-level batch. */
    #[On('open-batch-create')]
    public function openCreateBatch(): void
    {
        $this->reset(['batchName', 'batchBatch', 'batchCount', 'batchId']);
        $this->editBatch = false;
        $this->batchModal = true;
    }

    /** Open the batch modal prefilled from an existing batch. */
    #[On('open-batch-edit')]
    public function openEditBatch(int $id): void
    {
        $s = Student::findOrFail($id);
        $this->batchId    = $id;
        $this->batchName  = $s->name;
        $this->batchBatch = $s->batch ?? '';
        $this->batchCount = $s->number_of_student;
        $this->editBatch  = true;
        $this->batchModal = true;
    }

    /** Validate and create/update a batch (parent_id null), then emit 'student-changed'. */
    public function saveBatch(): void
    {
        $programId = $this->program()->id;

        $this->validate([
            // Batch names must be unique among the program's batches (top-level nodes).
            'batchName'  => ['required', Rule::unique('fetnet_student', 'name')
                ->where(fn ($q) => $q->where('program_id', $programId)->whereNull('parent_id')->whereNull('deleted_at'))
                ->ignore($this->batchId)],
            'batchBatch' => 'nullable',
            'batchCount' => 'required|integer|min:0',
        ], [
            'batchName.unique' => 'A batch with this name already exists.',
        ]);

        $data = [
            'name'              => $this->batchName,
            'batch'             => $this->batchBatch ?: null,
            'number_of_student' => $this->batchCount,
        ];

        if ($this->editBatch && $this->batchId) {
            Student::findOrFail($this->batchId)->update($data);
            $this->success('Batch updated.', position: 'toast-top toast-center');
        } else {
            Student::create(array_merge($data, ['program_id' => $this->program()->id, 'parent_id' => null]));
            $this->success('Batch added.', position: 'toast-top toast-center');
        }

        $this->batchModal = false;
        $this->dispatch('student-changed');
    }

    /** Open the group modal for a new child under the given parent. */
    #[On('open-group-create')]
    public function openAddGroup(int $parentId): void
    {
        $this->reset(['groupName', 'groupCount', 'groupId']);
        $this->groupParentId = $parentId;
        $this->editGroup     = false;
        $this->groupModal    = true;
    }

    /** Open the group modal prefilled from an existing group/sub-group. */
    #[On('open-group-edit')]
    public function openEditGroup(int $id): void
    {
        $g = Student::findOrFail($id);
        $this->groupId       = $id;
        $this->groupParentId = $g->parent_id;
        $this->groupName     = $g->name;
        $this->groupCount    = $g->number_of_student;
        $this->editGroup     = true;
        $this->groupModal    = true;
    }

    /** Validate and create/update a group/sub-group under its parent, emit 'student-changed'. */
    public function saveGroup(): void
    {
        $this->validate([
            // Group / sub-group names must be unique among siblings (same parent).
            'groupName'  => ['required', Rule::unique('fetnet_student', 'name')
                ->where(fn ($q) => $q->where('parent_id', $this->groupParentId)->whereNull('deleted_at'))
                ->ignore($this->groupId)],
            'groupCount' => 'required|integer|min:0',
        ], [
            'groupName.unique' => 'A group with this name already exists under this parent.',
        ]);

        $data = [
            'name'              => $this->groupName,
            'number_of_student' => $this->groupCount,
            'parent_id'         => $this->groupParentId,
        ];

        if ($this->editGroup && $this->groupId) {
            Student::findOrFail($this->groupId)->update($data);
            $this->success('Group updated.', position: 'toast-top toast-center');
        } else {
            Student::create(array_merge($data, ['program_id' => $this->program()->id]));
            $this->success('Group added.', position: 'toast-top toast-center');
        }

        $this->groupModal = false;
        $this->dispatch('student-changed');
    }
}; ?>

<div>
    <x-modal wire:model="batchModal" :title="$editBatch ? 'Edit Batch' : 'Add Batch'"
             separator class="modal-bottom" box-class="!max-w-md mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="saveBatch" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-input label="Batch Name" wire:model="batchName" placeholder="2021 Regular" required />
            <div class="grid grid-cols-3 gap-3">
                <x-input label="Year" wire:model="batchBatch" placeholder="2021" />
                <div class="col-span-2"><x-input label="Total Students" wire:model="batchCount" type="number" min="0" /></div>
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('batchModal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveBatch" />
            </x-slot:actions>
        </x-form>
    </x-modal>

    <x-modal wire:model="groupModal" :title="$editGroup ? 'Edit Group' : 'Add Group'"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="saveGroup" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="grid grid-cols-3 gap-3">
                <div class="col-span-2"><x-input label="Group Name" wire:model="groupName" placeholder="Group A" required /></div>
                <x-input label="# Students" wire:model="groupCount" type="number" min="0" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('groupModal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveGroup" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
