<?php

use App\Models\FetNet\CurriculumYear;
use App\Models\FetNet\Program;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal      = false;
    public ?int   $editId     = null;
    public string $yearValue  = '';
    public string $yearDesc   = '';

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function years(): array
    {
        $program = $this->program();
        if (! $program) return [];
        return CurriculumYear::where('program_id', $program->id)
            ->orderByDesc('year')->get()
            ->map(fn($y) => ['id' => $y->id, 'name' => $y->year, 'description' => $y->description])
            ->toArray();
    }

    #[On('open-curriculum-year-modal')]
    public function open(): void
    {
        $this->reset(['yearValue', 'yearDesc', 'editId']);
        $this->modal = true;
    }

    public function openEdit(int $id): void
    {
        $y = CurriculumYear::findOrFail($id);
        $this->editId    = $id;
        $this->yearValue = $y->year;
        $this->yearDesc  = $y->description ?? '';
    }

    public function cancelEdit(): void
    {
        $this->reset(['yearValue', 'yearDesc', 'editId']);
    }

    public function save(): void
    {
        $this->validate(['yearValue' => 'required|string|max:20']);
        if ($this->editId) {
            CurriculumYear::findOrFail($this->editId)->update([
                'year'        => trim($this->yearValue),
                'description' => trim($this->yearDesc) ?: null,
            ]);
            $this->success('Curriculum year updated.', position: 'toast-top toast-center');
        } else {
            CurriculumYear::firstOrCreate(
                ['program_id' => $this->program()->id, 'year' => trim($this->yearValue)],
                ['description' => trim($this->yearDesc) ?: null]
            );
            $this->success('Curriculum year added.', position: 'toast-top toast-center');
        }
        $this->reset(['yearValue', 'yearDesc', 'editId']);
        unset($this->years);
        $this->dispatch('refresh-subject-options');
    }

    public function delete(int $id): void
    {
        CurriculumYear::find($id)?->delete();
        unset($this->years);
        $this->dispatch('refresh-subject-options');
        $this->dispatch('curriculum-year-deleted', id: $id);
        $this->warning('Curriculum year removed.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Curriculum Years"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-3">
            <div class="divide-y divide-base-200">
                @forelse($this->years as $y)
                    <div wire:key="yr-{{ $y['id'] }}" class="flex items-center justify-between py-2 {{ $editId === $y['id'] ? 'bg-base-200/60 -mx-2 px-2 rounded' : '' }}">
                        <div class="text-sm">
                            <span class="font-medium">{{ $y['name'] }}</span>
                            @if(!empty($y['description']))<span class="text-base-content/30 mx-1">|</span><span class="text-base-content/50">{{ $y['description'] }}</span>@endif
                        </div>
                        <div class="flex gap-1">
                            <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square" wire:click="openEdit({{ $y['id'] }})" />
                            <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                      wire:click="delete({{ $y['id'] }})"
                                      wire:confirm="Delete this curriculum year? Subjects will be unlinked." />
                        </div>
                    </div>
                @empty
                    <p class="text-xs text-base-content/40 italic py-2">No curriculum years yet.</p>
                @endforelse
            </div>

            <div class="divider my-1"></div>

            <x-form wire:submit="save" class="space-y-3">
                @if($editId)<p class="text-xs text-primary font-medium">Editing — <button type="button" wire:click="cancelEdit" class="underline">cancel</button></p>@endif
                <div class="flex gap-2 items-end">
                    <x-input label="Year" wire:model="yearValue" placeholder="2020" class="w-28" />
                    <div class="flex-1"><x-input label="Description (optional)" wire:model="yearDesc" placeholder="Kurikulum Merdeka" /></div>
                    <x-button :icon="$editId ? 'o-check' : 'o-plus'" type="submit" class="btn-primary btn-sm mb-0.5" spinner="save" />
                </div>
            </x-form>
        </div>
        <x-slot:actions><x-button label="Done" icon="o-check" class="btn-primary" wire:click="$set('modal', false)" /></x-slot:actions>
    </x-modal>
</div>
