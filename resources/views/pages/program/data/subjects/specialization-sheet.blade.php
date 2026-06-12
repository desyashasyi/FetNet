<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\Specialization;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal      = false;
    public ?int   $editId     = null;
    public string $specCode   = '';
    public string $specAbbrev = '';
    public string $specName   = '';

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function specializations(): array
    {
        $program = $this->program();
        if (! $program) return [];
        return Specialization::where('program_id', $program->id)
            ->orderBy('code')->get()
            ->map(fn($s) => [
                'id' => $s->id, 'code' => $s->code,
                'abbrev' => $s->abbrev, 'sname' => $s->name,
            ])->toArray();
    }

    #[On('open-specialization-modal')]
    public function open(): void
    {
        $this->reset(['specCode', 'specAbbrev', 'specName', 'editId']);
        $this->modal = true;
    }

    public function openEdit(int $id): void
    {
        $s = Specialization::findOrFail($id);
        $this->editId    = $id;
        $this->specCode  = $s->code;
        $this->specAbbrev = $s->abbrev ?? '';
        $this->specName  = $s->name;
    }

    public function cancelEdit(): void
    {
        $this->reset(['specCode', 'specAbbrev', 'specName', 'editId']);
    }

    public function save(): void
    {
        $this->validate([
            'specCode' => 'required|string|max:10',
            'specName' => 'required|string|max:100',
        ]);
        if ($this->editId) {
            Specialization::findOrFail($this->editId)->update([
                'code'   => strtoupper(trim($this->specCode)),
                'abbrev' => strtoupper(trim($this->specAbbrev)) ?: null,
                'name'   => trim($this->specName),
            ]);
            $this->success('Specialization updated.', position: 'toast-top toast-center');
        } else {
            Specialization::firstOrCreate(
                ['program_id' => $this->program()->id, 'code' => strtoupper(trim($this->specCode))],
                ['abbrev' => strtoupper(trim($this->specAbbrev)) ?: null, 'name' => trim($this->specName)]
            );
            $this->success('Specialization added.', position: 'toast-top toast-center');
        }
        $this->reset(['specCode', 'specAbbrev', 'specName', 'editId']);
        unset($this->specializations);
        $this->dispatch('refresh-subject-options');
    }

    public function delete(int $id): void
    {
        Specialization::find($id)?->delete();
        unset($this->specializations);
        $this->dispatch('refresh-subject-options');
        $this->warning('Specialization removed.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Specializations"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-3">
            <div class="divide-y divide-base-200">
                @forelse($this->specializations as $s)
                    <div wire:key="sp-{{ $s['id'] }}" class="flex items-center justify-between py-2 {{ $editId === $s['id'] ? 'bg-base-200/60 -mx-2 px-2 rounded' : '' }}">
                        <div class="text-sm">
                            <span class="font-medium">{{ $s['code'] }}</span>
                            @if(!empty($s['abbrev']))<span class="text-base-content/30 mx-1">|</span><span class="text-base-content/60">{{ $s['abbrev'] }}</span>@endif
                            <span class="text-base-content/30 mx-1">|</span><span class="text-base-content/50">{{ $s['sname'] }}</span>
                        </div>
                        <div class="flex gap-1">
                            <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square" wire:click="openEdit({{ $s['id'] }})" />
                            <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                      wire:click="delete({{ $s['id'] }})"
                                      wire:confirm="Delete this specialization? Subjects using it will be unlinked." />
                        </div>
                    </div>
                @empty
                    <p class="text-xs text-base-content/40 italic py-2">No specializations yet.</p>
                @endforelse
            </div>

            <div class="divider my-1"></div>

            <x-form wire:submit="save" class="space-y-3">
                @if($editId)<p class="text-xs text-primary font-medium">Editing — <button type="button" wire:click="cancelEdit" class="underline">cancel</button></p>@endif
                <div class="grid grid-cols-2 gap-3">
                    <x-input label="Code" wire:model="specCode" placeholder="POWER" required />
                    <x-input label="Abbrev (optional)" wire:model="specAbbrev" placeholder="PWR" />
                </div>
                <div class="flex gap-2 items-end">
                    <div class="flex-1"><x-input label="Name" wire:model="specName" placeholder="Power Systems" required /></div>
                    <x-button :icon="$editId ? 'o-check' : 'o-plus'" type="submit" class="btn-primary mb-0.5" spinner="save" />
                </div>
            </x-form>
        </div>
        <x-slot:actions><x-button label="Done" icon="o-check" class="btn-primary" wire:click="$set('modal', false)" /></x-slot:actions>
    </x-modal>
</div>
