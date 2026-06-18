<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Students page for the signed-in program: renders the batch → group → sub-group
 * hierarchy as nested cards, with add/edit (via the form sheet) at each level and a
 * cascade delete. Uses HasProgramSemester for the year/semester context selectors.
 * Hosts student-form-sheet.
 */
new #[Layout('layouts.program')] class extends Component
{
    use Toast, HasProgramSemester;

    public bool $delModal = false;
    public ?int $deleteId = null;

    /** The signed-in user's program; scopes the hierarchy. */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Seed the academic-year/semester context for the program's client. */
    public function mount(): void
    {
        $program = $this->program();
        if ($program) $this->mountSemesterContext($program->client_id);
    }

    /** Open the form sheet for a batch / group at the right level. */
    public function openCreateBatch(): void { $this->dispatch('open-batch-create'); }
    public function openEditBatch(int $id): void { $this->dispatch('open-batch-edit', id: $id); }
    public function openAddGroup(int $parentId): void { $this->dispatch('open-group-create', parentId: $parentId); }
    public function openEditGroup(int $id): void { $this->dispatch('open-group-edit', id: $id); }

    /** Open the delete confirmation for a batch/group/sub-group. */
    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    /** Delete the confirmed node; descendants and activity links cascade away. */
    public function delete(): void
    {
        Student::findOrFail($this->deleteId)->delete();
        $this->delModal = false; $this->deleteId = null;
        $this->warning('Deleted (including sub-groups).', position: 'toast-top toast-center');
    }

    /** Re-render after the form sheet saves. */
    #[On('student-changed')]
    public function refreshFromChild(): void {}

    /** Top-level batches (parent_id null) with two levels of children eager-loaded. */
    public function with(): array
    {
        $program = $this->program();
        return [
            'batches' => $program
                ? Student::where('program_id', $program->id)->whereNull('parent_id')
                    ->with(['children.children'])->orderBy('batch')->orderBy('name')->get()
                : collect(),
        ];
    }
}; ?>

<div>
    <x-header title="Students" subtitle="Manage student batches & groups" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        @if(count($academicYearOptions))
            <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                      placeholder="Academic Year" class="w-36" />
        @endif
        @if(count($semesterOptions))
            <x-select wire:model.live="semesterId" :options="$semesterOptions"
                      placeholder="Semester" class="w-48" />
        @endif
        <div class="w-px h-6 bg-base-content/20 self-center"></div>
        <x-button label="Add Batch" icon="o-plus" class="btn-primary" wire:click="openCreateBatch" />
    </div>

    @forelse($batches as $batch)
        <x-card class="mb-3">
            <div class="flex items-start justify-between gap-3">
                <div class="flex-1">
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="font-semibold text-base-content">
                            {{ $batch->name }}
                            @if($batch->number_of_student)
                                <span class="text-base-content/40 font-normal">({{ $batch->number_of_student }})</span>
                            @endif
                        </span>
                    </div>

                    @if($batch->children->isNotEmpty())
                        <div class="mt-3 grid grid-cols-2 gap-2">
                            @foreach($batch->children as $group)
                                <div class="bg-base-200 rounded-xl p-3">
                                    <div class="flex items-center justify-between gap-1 mb-1">
                                        <span class="text-sm font-medium">
                                            {{ $group->name }}
                                            @if($group->number_of_student)
                                                <span class="text-base-content/40 font-normal">({{ $group->number_of_student }})</span>
                                            @endif
                                        </span>
                                        <div class="flex gap-0.5">
                                            <x-button icon="o-plus" class="btn-ghost btn-xs btn-square"
                                                      wire:click="openAddGroup({{ $group->id }})" tooltip="Add sub-group" />
                                            <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                                      wire:click="openEditGroup({{ $group->id }})" tooltip="Edit" />
                                            <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                                      wire:click="confirmDelete({{ $group->id }})" tooltip="Delete" />
                                        </div>
                                    </div>
                                    @if($group->children->isNotEmpty())
                                        <div class="mt-2 ml-3 border-l-2 border-base-300 pl-3 space-y-1">
                                            @foreach($group->children as $sub)
                                                <div class="flex items-center justify-between bg-base-100 rounded-lg px-2 py-1">
                                                    <span class="text-xs">{{ $sub->name }}
                                                        @if($sub->number_of_student)
                                                            <span class="text-base-content/40">({{ $sub->number_of_student }})</span>
                                                        @endif
                                                    </span>
                                                    <div class="flex gap-0.5">
                                                        <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                                                  wire:click="openEditGroup({{ $sub->id }})" tooltip="Edit" />
                                                        <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                                                  wire:click="confirmDelete({{ $sub->id }})" tooltip="Delete" />
                                                    </div>
                                                </div>
                                            @endforeach
                                        </div>
                                    @endif
                                </div>
                            @endforeach
                        </div>
                    @endif
                </div>

                <div class="flex gap-1 shrink-0">
                    <x-button icon="o-plus" class="btn-ghost btn-sm btn-square"
                              wire:click="openAddGroup({{ $batch->id }})" tooltip="Add group" />
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEditBatch({{ $batch->id }})" tooltip="Edit batch" />
                    <x-button icon="o-trash" class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $batch->id }})" tooltip="Delete batch" />
                </div>
            </div>
        </x-card>
    @empty
        <x-card>
            <p class="text-center text-base-content/50 py-6">No student data yet. Add a batch to get started.</p>
        </x-card>
    @endforelse

    <livewire:pages::program.data.students.student-form-sheet />

    <x-modal wire:model="delModal" title="Delete" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this item? All sub-groups and activity assignments will also be removed.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
