<?php

use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\Program;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int $programId = null;

    public bool   $modal       = false;
    public string $newTagName  = '';

    #[Computed]
    public function tags(): array
    {
        if (! $this->programId) return [];
        return ActivityTag::where('program_id', $this->programId)
            ->orderBy('name')->get()
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->name])->toArray();
    }

    #[On('open-tag-manager')]
    public function open(): void
    {
        $this->newTagName = '';
        $this->modal = true;
    }

    public function createTag(): void
    {
        $this->validate(['newTagName' => 'required|string|max:100']);
        if (! $this->programId) return;

        ActivityTag::firstOrCreate(['program_id' => $this->programId, 'name' => trim($this->newTagName)]);
        $this->newTagName = '';
        unset($this->tags);
        $this->success('Tag created.', position: 'toast-top toast-center');
        $this->dispatch('tags-changed');
    }

    public function deleteTag(int $tagId): void
    {
        ActivityTag::find($tagId)?->delete();
        unset($this->tags);
        $this->warning('Tag deleted.', position: 'toast-top toast-center');
        $this->dispatch('tags-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Manage Tags"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-3">
            <div class="flex flex-wrap gap-1.5 min-h-8">
                @forelse($this->tags as $tag)
                    <div wire:key="tag-{{ $tag['id'] }}" class="badge badge-outline gap-1">
                        {{ $tag['name'] }}
                        <button wire:click="deleteTag({{ $tag['id'] }})"
                                wire:confirm="Delete tag '{{ $tag['name'] }}'?"
                                class="hover:text-error ml-0.5 leading-none">×</button>
                    </div>
                @empty
                    <p class="text-xs text-base-content/40 italic">No tags yet.</p>
                @endforelse
            </div>

            <div class="divider my-1"></div>

            <x-form wire:submit="createTag" class="flex gap-2 items-end">
                <div class="flex-1">
                    <x-input label="New tag" wire:model="newTagName"
                             placeholder="e.g. Lab, Sports, Music" />
                </div>
                <x-button icon="o-plus" type="submit" class="btn-primary btn-sm mb-0.5"
                          spinner="createTag" />
            </x-form>
        </div>
        <x-slot:actions>
            <x-button label="Done" icon="o-check" class="btn-primary" wire:click="$set('modal', false)" />
        </x-slot:actions>
    </x-modal>
</div>
