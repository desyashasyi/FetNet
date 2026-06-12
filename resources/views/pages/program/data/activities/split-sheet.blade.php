<?php

use App\Models\FetNet\Activity;
use App\Models\FetNet\SubActivity;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool  $modal           = false;
    public ?int  $splitActivityId = null;
    public int   $splitTotal      = 0;
    public array $splits          = [];

    #[On('open-activity-split')]
    public function open(int $id): void
    {
        $activity              = Activity::with('subActivities')->findOrFail($id);
        $this->splitActivityId = $id;
        $this->splitTotal      = $activity->duration;

        $this->splits = $activity->subActivities->isNotEmpty()
            ? $activity->subActivities->map(fn($s) => ['duration' => $s->duration])->toArray()
            : [['duration' => $activity->duration]];

        $this->modal = true;
    }

    public function addSplit(): void
    {
        $this->splits[] = ['duration' => 1];
    }

    public function removeSplit(int $index): void
    {
        array_splice($this->splits, $index, 1);
        $this->splits = array_values($this->splits);
    }

    public function saveSplits(): void
    {
        $used = collect($this->splits)->sum('duration');

        if ($used !== $this->splitTotal) {
            $this->addError('splits', "Total duration must equal {$this->splitTotal} hrs (current: {$used}).");
            return;
        }

        SubActivity::where('activity_id', $this->splitActivityId)->delete();

        foreach ($this->splits as $i => $split) {
            SubActivity::create([
                'activity_id' => $this->splitActivityId,
                'duration'    => max(1, (int) $split['duration']),
                'order'       => $i,
            ]);
        }

        $this->modal = false;
        $this->success('Sub-activities saved.', position: 'toast-top toast-center');
        $this->dispatch('activity-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Split Activity"
             separator class="modal-bottom" box-class="!max-w-sm mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-3">
            <p class="text-sm text-base-content/60">
                Total duration: <span class="font-semibold text-base-content">{{ $splitTotal }} hrs</span>
                &nbsp;|&nbsp; Used:
                <span x-data x-text="$wire.splits.reduce((s,r)=>s+(+r.duration||0),0)"
                      :class="$wire.splits.reduce((s,r)=>s+(+r.duration||0),0)==={{ $splitTotal }} ? 'text-success font-semibold' : 'text-error font-semibold'">0</span> hrs
            </p>

            @error('splits')
                <p class="text-error text-sm">{{ $message }}</p>
            @enderror

            @foreach($splits as $i => $split)
                <div wire:key="split-{{ $i }}" class="flex items-center gap-2">
                    <span class="text-xs text-base-content/40 w-4">{{ $i + 1 }}</span>
                    <x-input wire:model.live="splits.{{ $i }}.duration"
                             type="number" min="1" max="{{ $splitTotal }}"
                             class="flex-1" placeholder="Duration (hrs)" />
                    @if(count($splits) > 1)
                        <x-button icon="o-x-mark" class="btn-ghost btn-sm btn-square text-error"
                                  wire:click="removeSplit({{ $i }})" />
                    @endif
                </div>
            @endforeach

            <x-button label="Add Sub-Activity" icon="o-plus" class="btn-ghost btn-sm w-full"
                      wire:click="addSplit" />
        </div>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
            <x-button label="Save"   icon="o-check-circle" class="btn-primary" wire:click="saveSplits" spinner="saveSplits" />
        </x-slot:actions>
    </x-modal>
</div>
