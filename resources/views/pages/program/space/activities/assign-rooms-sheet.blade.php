<?php

use App\Models\FetNet\Activity;
use App\Models\FetNet\Building;
use App\Models\FetNet\Program;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceClaim;
use App\Models\FetNet\SpaceType;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Assign-rooms sheet for one activity: two panes — available rooms (the program's
 * client-accepted spaces, filterable by building/type/capacity) and already-assigned
 * rooms. Program can add/remove rooms it assigned ('program' on the pivot) but not those
 * the client locked in ('client'). Each change broadcasts 'rooms-changed' for the parent.
 */
new class extends Component
{
    use Toast;

    public bool   $modal                 = false;
    public bool   $confirmAssignAllModal = false;
    public bool   $confirmRemoveAllModal = false;
    public ?int   $assignActivityId      = null;
    public array  $assignSpaceIds        = [];
    public ?int   $buildingFilter        = null;
    public ?int   $typeFilter            = null;
    public string $capacityFilter        = '';
    public int    $assignPage            = 1;
    public int    $assignedPage          = 1;
    public string $subjectName           = '';
    public string $subjectCode           = '';
    public int    $studentCount          = 0;
    public array  $buildingOptions       = [];
    public array  $typeOptions           = [];

    public array $capacityOptions = [
        ['id' => '',      'name' => 'All Capacity'],
        ['id' => '1-20',  'name' => '1 – 20'],
        ['id' => '21-30', 'name' => '21 – 30'],
        ['id' => '31-50', 'name' => '31 – 50'],
        ['id' => '51-999','name' => '> 50'],
    ];

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Open for one activity: load its current rooms, subject info, headcount, and filters. */
    #[On('open-assign-rooms')]
    public function open(int $activityId): void
    {
        $program  = $this->program();
        $activity = Activity::with(['planning.subject', 'students'])->findOrFail($activityId);

        $this->assignActivityId = $activityId;
        $this->assignSpaceIds   = $activity->spaces()->pluck('fetnet_space.id')->toArray();
        $this->buildingFilter   = null;
        $this->typeFilter       = null;
        $this->capacityFilter   = '';
        $this->assignPage       = 1;
        $this->assignedPage     = 1;
        $this->subjectName      = $activity->planning?->subject?->name ?? '—';
        $this->subjectCode      = $activity->planning?->subject?->code ?? '';
        $this->studentCount     = $activity->students->sum('number_of_student');

        $this->buildingOptions = Building::where('client_id', $program?->client_id)
            ->orderBy('name')->get(['id', 'name'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->name])->toArray();

        $this->typeOptions = SpaceType::orderBy('name')->get(['id', 'name'])
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->name])->toArray();

        $this->modal = true;
    }

    /** Filter changes reset the available-rooms page. */
    public function updatedBuildingFilter(): void { $this->assignPage = 1; }
    public function updatedTypeFilter(): void     { $this->assignPage = 1; }
    public function updatedCapacityFilter(): void { $this->assignPage = 1; }

    /** In-memory pagers for the available and assigned room lists. */
    public function assignPrev(): void { if ($this->assignPage > 1) $this->assignPage--; }
    public function assignNext(int $last): void { if ($this->assignPage < $last) $this->assignPage++; }
    public function assignedPrev(): void { if ($this->assignedPage > 1) $this->assignedPage--; }
    public function assignedNext(int $last): void { if ($this->assignedPage < $last) $this->assignedPage++; }

    /** Assign one room to the activity (pivot assigned_by = 'program'); broadcast change. */
    public function selectSpace(int $spaceId): void
    {
        Activity::findOrFail($this->assignActivityId)->spaces()->syncWithoutDetaching([$spaceId => ['assigned_by' => 'program']]);
        $this->assignSpaceIds[] = $spaceId;
        $this->assignSpaceIds   = array_values(array_unique($this->assignSpaceIds));
        $this->success('Space assigned.', position: 'toast-top toast-center');
        $this->dispatch('rooms-changed');
    }

    /** Remove a room — only if the program assigned it; client-locked rooms are protected. */
    public function removeSpace(int $spaceId): void
    {
        $pivot = \DB::table('fetnet_activity_space')
            ->where('activity_id', $this->assignActivityId)
            ->where('space_id', $spaceId)
            ->value('assigned_by');

        if ($pivot !== 'program') {
            $this->error('Ruangan ini di-assign oleh client dan tidak dapat dihapus.', position: 'toast-top toast-center');
            return;
        }

        Activity::findOrFail($this->assignActivityId)->spaces()->detach($spaceId);
        $this->assignSpaceIds = array_values(array_filter($this->assignSpaceIds, fn($id) => $id !== $spaceId));
        $last = max(1, (int) ceil(count($this->assignSpaceIds) / 10));
        if ($this->assignedPage > $last) $this->assignedPage = $last;
        $this->warning('Space removed.', position: 'toast-top toast-center');
        $this->dispatch('rooms-changed');
    }

    /** Remove every program-assigned room from the activity (client rooms untouched). */
    public function removeAll(): void
    {
        $programSpaceIds = \DB::table('fetnet_activity_space')
            ->where('activity_id', $this->assignActivityId)
            ->where('assigned_by', 'program')
            ->pluck('space_id')->toArray();

        if (empty($programSpaceIds)) {
            $this->error('Tidak ada ruangan program yang bisa dihapus.', position: 'toast-top toast-center');
            return;
        }

        Activity::findOrFail($this->assignActivityId)->spaces()->detach($programSpaceIds);
        $this->assignSpaceIds = array_values(array_filter($this->assignSpaceIds, fn($id) => !in_array($id, $programSpaceIds)));
        $this->assignedPage          = 1;
        $this->confirmRemoveAllModal = false;
        $this->warning('Ruangan program dihapus.', position: 'toast-top toast-center');
        $this->dispatch('rooms-changed');
    }

    /** Assign every room matching the current filters (excluding already-assigned). */
    public function selectAll(): void
    {
        $program = $this->program();
        $ids = Space::where('client_id', $program?->client_id)
            ->when($this->buildingFilter, fn($q) => $q->where('building_id', $this->buildingFilter))
            ->when($this->typeFilter,     fn($q) => $q->where('type_id', $this->typeFilter))
            ->when($this->capacityFilter, function ($q) {
                [$min, $max] = explode('-', $this->capacityFilter);
                $q->where('capacity', '>=', (int)$min)->where('capacity', '<=', (int)$max);
            })
            ->whereNotIn('id', $this->assignSpaceIds)
            ->pluck('id')->toArray();

        if (empty($ids)) return;

        Activity::findOrFail($this->assignActivityId)->spaces()->syncWithoutDetaching($ids);
        $this->assignSpaceIds = array_values(array_unique(array_merge($this->assignSpaceIds, $ids)));
        $this->assignPage = 1;
        $this->confirmAssignAllModal = false;
        $this->success(count($ids) . ' rooms assigned.', position: 'toast-top toast-center');
        $this->dispatch('rooms-changed');
    }

    /**
     * View data: the paged available rooms (from the program's client-accepted spaces,
     * minus already-assigned, honouring filters) and the paged assigned rooms decorated
     * with their assigned_by source, plus totals/last-page for each pager.
     */
    public function with(): array
    {
        $program = $this->program();
        $perPage = 10;

        $acceptedSpaceIds = $program
            ? SpaceClaim::where('program_id', $program->id)->where('status', 'accepted')->pluck('space_id')->toArray()
            : [];

        $spaceQuery = ($this->modal && count($acceptedSpaceIds))
            ? Space::with('building:id,name')
                ->whereIn('id', $acceptedSpaceIds)
                ->when($this->buildingFilter, fn($q) => $q->where('building_id', $this->buildingFilter))
                ->when($this->typeFilter,     fn($q) => $q->where('type_id', $this->typeFilter))
                ->when($this->capacityFilter, function ($q) {
                    [$min, $max] = explode('-', $this->capacityFilter);
                    $q->where('capacity', '>=', (int)$min)->where('capacity', '<=', (int)$max);
                })
                ->when($this->assignSpaceIds, fn($q) => $q->whereNotIn('id', $this->assignSpaceIds))
                ->orderBy('name')
            : null;

        $assignTotal    = $spaceQuery?->count() ?? 0;
        $assignLastPage = max(1, (int) ceil($assignTotal / $perPage));
        $assignSpaces   = $spaceQuery
            ? $spaceQuery->offset(($this->assignPage - 1) * $perPage)->limit($perPage)->get()
            : collect();

        $assignedTotal    = count($this->assignSpaceIds);
        $assignedLastPage = max(1, (int) ceil($assignedTotal / $perPage));
        $assignedSpaces   = ($this->modal && $assignedTotal)
            ? Space::with('building:id,name')
                ->whereIn('id', $this->assignSpaceIds)
                ->orderBy('name')
                ->offset(($this->assignedPage - 1) * $perPage)->limit($perPage)->get()
                ->map(function ($s) {
                    $s->assigned_by = \DB::table('fetnet_activity_space')
                        ->where('activity_id', $this->assignActivityId)
                        ->where('space_id', $s->id)
                        ->value('assigned_by') ?? 'client';
                    return $s;
                })
            : collect();

        return compact('assignSpaces', 'assignTotal', 'assignLastPage', 'assignedSpaces', 'assignedTotal', 'assignedLastPage');
    }
}; ?>

<div>
    <x-modal wire:model="modal" separator class="modal-bottom"
             title="Assign Rooms"
             box-class="!max-w-5xl mx-auto !rounded-t-2xl !mb-16">

        <div class="flex items-center gap-2 mb-3 -mt-1">
            <span class="font-bold text-sm">{{ $subjectCode }}</span>
            <span class="text-base-content/60 text-sm">{{ $subjectName }}</span>
            @if($studentCount)
                <span class="badge badge-ghost badge-sm">{{ $studentCount }} students</span>
            @endif
        </div>

        <div class="grid grid-cols-2 gap-4 min-h-[400px]">
            <div class="flex flex-col gap-2">
                <p class="text-xs font-semibold text-base-content/50 uppercase tracking-wide">Available Rooms</p>

                <div class="flex flex-col gap-2">
                    <select wire:model.live="buildingFilter" class="select select-sm select-bordered w-full">
                        <option value="">All Buildings</option>
                        @foreach($buildingOptions as $b)
                            <option value="{{ $b['id'] }}">{{ $b['name'] }}</option>
                        @endforeach
                    </select>
                    <div class="flex gap-2">
                        <select wire:model.live="typeFilter" class="select select-sm select-bordered flex-1 min-w-0">
                            <option value="">All Types</option>
                            @foreach($typeOptions as $t)
                                <option value="{{ $t['id'] }}">{{ $t['name'] }}</option>
                            @endforeach
                        </select>
                        <select wire:model.live="capacityFilter" class="select select-sm select-bordered w-32">
                            @foreach($capacityOptions as $c)
                                <option value="{{ $c['id'] }}">{{ $c['name'] }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <div class="flex-1 border border-base-300 rounded-lg overflow-hidden">
                    @if($assignSpaces->isEmpty())
                        <p class="text-center text-base-content/30 py-8 text-sm italic">No available rooms</p>
                    @else
                        <table class="table table-xs w-full">
                            <thead>
                                <tr class="bg-base-200">
                                    <th>Room</th><th>Building</th><th class="text-center">Cap.</th>
                                    <th class="text-right">
                                        <x-button label="Assign All" icon="o-plus-circle"
                                                  class="btn-ghost btn-xs text-success"
                                                  wire:click="$set('confirmAssignAllModal', true)" />
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($assignSpaces as $space)
                                    <tr wire:key="av-{{ $space->id }}" class="hover:bg-base-100">
                                        <td class="font-medium text-xs">{{ $space->name }}</td>
                                        <td class="text-xs text-base-content/50">{{ $space->building?->name ?? '—' }}</td>
                                        <td class="text-center text-xs">{{ $space->capacity ?? '—' }}</td>
                                        <td class="text-right">
                                            <x-button icon="o-plus-circle" class="btn-ghost btn-xs btn-square text-success"
                                                      wire:click="selectSpace({{ $space->id }})" />
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    @endif
                </div>

                @if($assignLastPage > 1)
                    <div class="flex justify-between items-center text-xs text-base-content/50">
                        <button wire:click="assignPrev" class="btn btn-xs btn-ghost" @if($assignPage <= 1) disabled @endif>‹ Prev</button>
                        <span>{{ $assignPage }} / {{ $assignLastPage }}</span>
                        <button wire:click="assignNext({{ $assignLastPage }})" class="btn btn-xs btn-ghost" @if($assignPage >= $assignLastPage) disabled @endif>Next ›</button>
                    </div>
                @endif
            </div>

            <div class="flex flex-col gap-2">
                <p class="text-xs font-semibold text-base-content/50 uppercase tracking-wide">Assigned Rooms</p>

                <div class="flex-1 border border-base-300 rounded-lg overflow-hidden">
                    @if($assignedSpaces->isEmpty())
                        <p class="text-center text-base-content/30 py-8 text-sm italic">No rooms assigned yet</p>
                    @else
                        <table class="table table-xs w-full">
                            <thead>
                                <tr class="bg-base-200">
                                    <th>Room</th><th>Building</th><th class="text-center">Cap.</th>
                                    <th class="text-right">
                                        @if($assignedTotal)
                                            <x-button label="Remove All" icon="o-trash"
                                                      class="btn-ghost btn-xs text-error"
                                                      wire:click="$set('confirmRemoveAllModal', true)" />
                                        @endif
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($assignedSpaces as $space)
                                    <tr wire:key="as-{{ $space->id }}" class="hover:bg-base-100">
                                        <td class="font-medium text-xs">{{ $space->name }}</td>
                                        <td class="text-xs text-base-content/50">{{ $space->building?->name ?? '—' }}</td>
                                        <td class="text-center text-xs">{{ $space->capacity ?? '—' }}</td>
                                        <td class="text-right">
                                            @if(($space->assigned_by ?? 'client') === 'program')
                                                <x-button icon="o-minus-circle" class="btn-ghost btn-xs btn-square text-error"
                                                          wire:click="removeSpace({{ $space->id }})" />
                                            @else
                                                <x-icon name="o-lock-closed" class="w-3.5 h-3.5 text-base-content/30 mx-auto" />
                                            @endif
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    @endif
                </div>

                @if($assignedLastPage > 1)
                    <div class="flex justify-between items-center text-xs text-base-content/50">
                        <button wire:click="assignedPrev" class="btn btn-xs btn-ghost" @if($assignedPage <= 1) disabled @endif>‹ Prev</button>
                        <span>{{ $assignedPage }} / {{ $assignedLastPage }}</span>
                        <button wire:click="assignedNext({{ $assignedLastPage }})" class="btn btn-xs btn-ghost" @if($assignedPage >= $assignedLastPage) disabled @endif>Next ›</button>
                    </div>
                @endif
            </div>
        </div>
    </x-modal>

    <x-modal wire:model="confirmAssignAllModal" title="Assign All Rooms" separator box-class="!max-w-sm">
        <p class="text-sm">Assign semua ruangan yang sesuai filter ke aktivitas ini?</p>
        <x-slot:actions>
            <x-button label="Batal" wire:click="$set('confirmAssignAllModal', false)" />
            <x-button label="Assign All" icon="o-plus-circle" class="btn-success" wire:click="selectAll" />
        </x-slot:actions>
    </x-modal>

    <x-modal wire:model="confirmRemoveAllModal" title="Remove Program Rooms" separator box-class="!max-w-sm">
        <p class="text-sm">Hapus semua ruangan yang di-assign oleh program dari aktivitas ini? Ruangan yang di-assign oleh client tidak akan terhapus.</p>
        <x-slot:actions>
            <x-button label="Batal" wire:click="$set('confirmRemoveAllModal', false)" />
            <x-button label="Remove All" icon="o-trash" class="btn-error" wire:click="removeAll" />
        </x-slot:actions>
    </x-modal>
</div>
