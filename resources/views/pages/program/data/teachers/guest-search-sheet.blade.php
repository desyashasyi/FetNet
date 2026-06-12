<?php

use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal       = false;
    public string $guestSearch = '';
    public array  $guestResults = [];

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    private function clusterProgramIds(Program $program): array
    {
        $entry = Cluster::where('program_id', $program->id)->first();
        if (! $entry) return [$program->id];
        return Cluster::where('cluster_base_id', $entry->cluster_base_id)
            ->pluck('program_id')->toArray();
    }

    #[On('open-guest-search')]
    public function open(): void
    {
        $this->reset(['guestSearch', 'guestResults']);
        $this->modal = true;
    }

    public function searchGuest(): void
    {
        $program  = $this->program();
        $ownIds   = $this->clusterProgramIds($program);
        $guestIds = $program->guestTeachers()->pluck('teacher_id')->toArray();

        $this->guestResults = Teacher::with('program:id,abbrev,name')
            ->whereNotIn('program_id', $ownIds)
            ->whereNotIn('id', $guestIds)
            ->where(fn($q) => $q
                ->where('name',        'like', "%{$this->guestSearch}%")
                ->orWhere('code',       'like', "%{$this->guestSearch}%")
                ->orWhere('employee_id','like', "%{$this->guestSearch}%"))
            ->orderBy('name')->limit(20)
            ->get(['id', 'program_id', 'code', 'name', 'front_title', 'rear_title'])
            ->map(fn($t) => [
                'id'       => $t->id,
                'name'     => $t->full_name,
                'prodi'    => $t->program?->abbrev ?? '-',
                'prodi_nm' => $t->program?->name ?? '',
            ])->toArray();
    }

    public function addGuestTeacher(int $teacherId): void
    {
        $this->program()->guestTeachers()->syncWithoutDetaching([$teacherId]);
        $this->searchGuest();
        $this->success('Guest teacher added.', position: 'toast-top toast-center');
        $this->dispatch('teacher-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Search Guest Teacher"
             separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <p class="text-sm text-base-content/60">Search for teachers from programs outside your cluster. Guest teachers can be assigned to activities but cannot be edited here.</p>
            <div class="flex gap-2">
                <x-input wire:model="guestSearch" placeholder="Name, code, or employee ID..." class="flex-1" clearable />
                <x-button label="Search" icon="o-magnifying-glass" class="btn-primary" wire:click="searchGuest" />
            </div>

            @if(count($guestResults))
                <div class="divide-y divide-base-200">
                    @foreach($guestResults as $r)
                        <div wire:key="gr-{{ $r['id'] }}" class="flex items-center justify-between py-2">
                            <div>
                                <div class="font-medium text-sm">{{ $r['name'] }}</div>
                                <div class="text-xs text-base-content/50 flex items-center gap-1">
                                    <x-badge value="{{ $r['prodi'] }}" class="badge-xs badge-neutral" />
                                    {{ $r['prodi_nm'] }}
                                </div>
                            </div>
                            <x-button icon="o-plus" class="btn-primary btn-sm btn-square"
                                      wire:click="addGuestTeacher({{ $r['id'] }})" tooltip="Add as guest teacher" />
                        </div>
                    @endforeach
                </div>
            @elseif($guestSearch !== '')
                <p class="text-center text-sm text-base-content/40 py-4">No results found.</p>
            @endif
        </div>
    </x-modal>
</div>
