<?php

use App\Models\FetNet\Program;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceClaim;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal           = false;
    public string $claimQuery      = '';
    public array  $availableSpaces = [];
    public int    $claimPage       = 1;
    public int    $spacePage       = 1;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function myClaims()
    {
        $program = $this->program();
        return $program
            ? SpaceClaim::where('program_id', $program->id)
                ->with('space:id,name,capacity')
                ->orderByRaw("CASE status WHEN 'accepted' THEN 0 WHEN 'pending' THEN 1 ELSE 2 END")
                ->orderBy('created_at', 'desc')->get()
            : collect();
    }

    #[On('open-claim')]
    public function open(): void
    {
        $this->claimQuery = '';
        $this->claimPage  = 1;
        $this->spacePage  = 1;
        $this->searchAvailableSpaces();
        $this->modal = true;
    }

    public function updatedClaimQuery(): void
    {
        $this->spacePage = 1;
        $this->searchAvailableSpaces();
    }

    public function searchAvailableSpaces(): void
    {
        $program = $this->program();
        if (! $program) { $this->availableSpaces = []; return; }

        $this->availableSpaces = Space::where('client_id', $program->client_id)
            ->when($this->claimQuery, fn($q) => $q->where(fn($q2) => $q2
                ->where('name', 'like', "%{$this->claimQuery}%")
                ->orWhere('code', 'like', "%{$this->claimQuery}%")))
            ->with(['claims' => fn($q) => $q->where('program_id', $program->id)])
            ->orderBy('name')->get()
            ->map(fn($s) => [
                'id'       => $s->id,
                'name'     => $s->name,
                'capacity' => $s->capacity,
                'claim'    => $s->claims->first(),
            ])->toArray();
    }

    public function claimSpace(int $spaceId): void
    {
        $program = $this->program();
        if (! $program) return;
        SpaceClaim::updateOrCreate(
            ['space_id' => $spaceId, 'program_id' => $program->id],
            ['status' => 'pending', 'responded_at' => null]
        );
        $this->searchAvailableSpaces();
        unset($this->myClaims);
        $this->success('Claim request sent.', position: 'toast-top toast-center');
    }

    public function cancelClaim(int $claimId): void
    {
        $program = $this->program();
        if (! $program) return;
        SpaceClaim::where('id', $claimId)->where('program_id', $program->id)->delete();
        $this->searchAvailableSpaces();
        unset($this->myClaims);
        $this->warning('Claim cancelled.', position: 'toast-top toast-center');
    }

    public function claimPagePrev(): void { if ($this->claimPage > 1) $this->claimPage--; }
    public function claimPageNext(int $last): void { if ($this->claimPage < $last) $this->claimPage++; }
    public function spacePagePrev(): void { if ($this->spacePage > 1) $this->spacePage--; }
    public function spacePageNext(int $last): void { if ($this->spacePage < $last) $this->spacePage++; }
}; ?>

<div>
    <x-modal wire:model="modal" title="Manage Spaces"
             separator class="modal-bottom" box-class="!max-w-lg mx-auto !rounded-t-2xl !mb-16">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />

            @if($this->myClaims->isNotEmpty())
                @php
                    $cp = 3; $ct = $this->myClaims->count();
                    $clp = max(1, (int) ceil($ct / $cp));
                    $cs  = $this->myClaims->slice(($claimPage - 1) * $cp, $cp);
                @endphp
                <div class="divide-y divide-base-200">
                    @foreach($cs as $claim)
                        <div wire:key="cl-{{ $claim->id }}" class="flex items-center justify-between py-2 gap-2">
                            <div class="flex-1 min-w-0">
                                <span class="text-sm font-medium">{{ $claim->space?->name }}</span>
                                @if($claim->space?->capacity)
                                    <span class="text-xs text-base-content/40 ml-1">({{ $claim->space->capacity }})</span>
                                @endif
                            </div>
                            <div class="flex items-center gap-1 shrink-0">
                                @if($claim->status === 'accepted')
                                    <x-icon name="o-check-circle" class="w-4 h-4 text-success" />
                                @elseif($claim->status === 'pending')
                                    <x-icon name="o-clock" class="w-4 h-4 text-warning" />
                                @else
                                    <x-icon name="o-x-circle" class="w-4 h-4 text-error" />
                                @endif
                                <x-button icon="o-no-symbol" class="btn-ghost btn-xs btn-square text-error"
                                          wire:click="cancelClaim({{ $claim->id }})"
                                          tooltip="{{ $claim->status === 'accepted' ? 'Remove' : 'Cancel' }}" />
                            </div>
                        </div>
                    @endforeach
                </div>
                @if($clp > 1)
                    <div class="flex justify-between items-center text-xs text-base-content/50">
                        <button wire:click="claimPagePrev" class="btn btn-xs btn-ghost" @if($claimPage <= 1) disabled @endif>‹ Prev</button>
                        <span>{{ $claimPage }} / {{ $clp }}</span>
                        <button wire:click="claimPageNext({{ $clp }})" class="btn btn-xs btn-ghost" @if($claimPage >= $clp) disabled @endif>Next ›</button>
                    </div>
                @endif
            @else
                <p class="text-sm text-base-content/40 text-center py-2 italic">No spaces claimed yet.</p>
            @endif

            <div class="border border-base-200 rounded-xl p-4 space-y-3">
                <p class="text-sm font-semibold text-base-content/70">Find & Claim Spaces</p>
                <x-input wire:model.live.debounce="claimQuery" placeholder="Search by name or code..."
                         icon="o-magnifying-glass" clearable />
                @php
                    $sp = 3; $st = count($availableSpaces);
                    $slp = max(1, (int) ceil($st / $sp));
                    $ss  = array_slice($availableSpaces, ($spacePage - 1) * $sp, $sp);
                @endphp
                <div class="divide-y divide-base-200">
                    @forelse($ss as $s)
                        @php $c = $s['claim'] ?? null; @endphp
                        <div wire:key="av-{{ $s['id'] }}" class="flex items-center justify-between py-2 gap-2">
                            <div class="flex-1 min-w-0">
                                <span class="text-sm font-medium">{{ $s['name'] }}</span>
                                @if($s['capacity'] ?? null)
                                    <span class="text-xs text-base-content/40 ml-1">({{ $s['capacity'] }})</span>
                                @endif
                            </div>
                            @if($c && $c->status === 'accepted')
                                <x-icon name="o-check-circle" class="w-4 h-4 text-success shrink-0" />
                            @elseif($c && $c->status === 'pending')
                                <x-icon name="o-clock" class="w-4 h-4 text-warning shrink-0" />
                            @else
                                <x-button label="Claim" icon="o-hand-raised" class="btn-primary btn-xs shrink-0"
                                          wire:click="claimSpace({{ $s['id'] }})" />
                            @endif
                        </div>
                    @empty
                        <p class="text-sm text-base-content/40 text-center py-3 italic">No spaces found.</p>
                    @endforelse
                </div>
                @if($slp > 1)
                    <div class="flex justify-between items-center text-xs text-base-content/50 pt-1">
                        <button wire:click="spacePagePrev" class="btn btn-xs btn-ghost" @if($spacePage <= 1) disabled @endif>‹ Prev</button>
                        <span>{{ $spacePage }} / {{ $slp }}</span>
                        <button wire:click="spacePageNext({{ $slp }})" class="btn btn-xs btn-ghost" @if($spacePage >= $slp) disabled @endif>Next ›</button>
                    </div>
                @endif
            </div>
        </div>
    </x-modal>
</div>
