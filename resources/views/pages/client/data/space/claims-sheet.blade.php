<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\SpaceClaim;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool $modal = false;

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    #[Computed]
    public function pendingClaims()
    {
        $clientId = $this->client()?->id;
        return $clientId
            ? SpaceClaim::with(['space:id,name,code', 'program:id,abbrev,name'])
                ->whereHas('space', fn($q) => $q->where('client_id', $clientId))
                ->where('status', 'pending')
                ->orderBy('created_at')->get()
            : collect();
    }

    #[On('open-claims')]
    public function open(): void
    {
        unset($this->pendingClaims);
        $this->modal = true;
    }

    public function acceptClaim(int $id): void
    {
        SpaceClaim::findOrFail($id)->update(['status' => 'accepted', 'responded_at' => now()]);
        unset($this->pendingClaims);
        $this->success('Claim accepted.', position: 'toast-top toast-center');
        $this->dispatch('claims-changed');
    }

    public function rejectClaim(int $id): void
    {
        SpaceClaim::findOrFail($id)->update(['status' => 'rejected', 'responded_at' => now()]);
        unset($this->pendingClaims);
        $this->warning('Claim rejected.', position: 'toast-top toast-center');
        $this->dispatch('claims-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Space Claim Requests"
             separator class="modal-bottom" box-class="!max-w-2xl mx-auto !rounded-t-2xl !mb-14">
        <div>
            @if($this->pendingClaims->isNotEmpty())
                <div class="overflow-hidden">
                    <table class="table table-sm table-zebra w-full">
                        <thead>
                            <tr class="text-base-content/60 text-xs">
                                <th class="w-7/12">Room Name</th>
                                <th class="w-1/12">Code</th>
                                <th class="w-2/12">Req. By</th>
                                <th class="w-2/12 text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($this->pendingClaims as $claim)
                            <tr wire:key="claim-{{ $claim->id }}" class="hover:bg-base-200/40">
                                <td class="font-medium text-sm">{{ $claim->space?->name ?? '—' }}</td>
                                <td>
                                    @if($claim->space?->code)
                                        <x-badge value="{{ $claim->space->code }}" class="badge-neutral badge-sm" />
                                    @else
                                        <span class="text-base-content/30">—</span>
                                    @endif
                                </td>
                                <td class="text-sm font-semibold">{{ $claim->program?->abbrev ?? '—' }}</td>
                                <td>
                                    <div class="flex justify-end gap-1">
                                        <x-button icon="o-check-circle" class="btn-success btn-xs btn-square"
                                                  wire:click="acceptClaim({{ $claim->id }})" tooltip="Accept" />
                                        <x-button icon="o-x-circle" class="btn-error btn-xs btn-square"
                                                  wire:click="rejectClaim({{ $claim->id }})" tooltip="Reject" />
                                    </div>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            @else
                <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                    <x-icon name="o-bell-slash" class="w-10 h-10" />
                    <p class="text-sm">No pending claim requests.</p>
                </div>
            @endif
        </div>
        <x-slot:actions>
            <x-button label="Close" icon="o-x-circle" wire:click="$set('modal', false)" />
        </x-slot:actions>
    </x-modal>
</div>
