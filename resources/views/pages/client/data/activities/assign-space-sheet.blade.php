<?php

use App\Jobs\FetNet\AssignSpacesToActivityJob;
use App\Jobs\FetNet\RemoveAllSpacesFromActivityJob;
use App\Models\FetNet\Activity;
use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceType;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal              = false;
    public ?int   $assignActivityId   = null;
    public array  $assignSpaceIds     = [];
    public ?int   $buildingFilter     = null;
    public ?int   $typeFilter         = null;
    public string $capacityFilter     = '';
    public int    $assignPage         = 1;
    public int    $assignedPage       = 1;
    public array  $buildingOptions    = [];
    public array  $typeOptions        = [];
    public string $subjectName        = '';
    public string $subjectCode        = '';
    public int    $studentCount       = 0;

    public array $capacityOptions = [
        ['id' => '1-20',   'name' => '1 – 20'],
        ['id' => '20-40',  'name' => '20 – 40'],
        ['id' => '40-50',  'name' => '40 – 50'],
        ['id' => '50-999', 'name' => '50+'],
    ];

    public function getListeners(): array
    {
        return ['echo:activity-spaces,.ActivitySpacesUpdatedEvent' => 'onSpacesUpdated'];
    }

    public function onSpacesUpdated(array $event): void
    {
        $eventActivityId = $event['activityId'] ?? $event['activity_id'] ?? null;
        if ($this->modal && $this->assignActivityId === $eventActivityId) {
            $activity = Activity::find($this->assignActivityId);
            $this->assignSpaceIds = $activity
                ? $activity->spaces()->pluck('fetnet_space.id')->toArray()
                : [];
            $this->assignedPage = 1;
        }

        ($event['status'] ?? '') === 'success'
            ? $this->success($event['message'], position: 'toast-top toast-center')
            : $this->error($event['message'],   position: 'toast-top toast-center');

        $this->dispatch('activity-spaces-changed');
    }

    #[On('open-assign-space')]
    public function open(int $activityId): void
    {
        $client   = Client::where('user_id', auth()->id())->first();
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

        $this->buildingOptions = Building::where('client_id', $client?->id)
            ->orderBy('name')->get(['id', 'name', 'code'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->code ? "{$b->code} {$b->name}" : $b->name])
            ->toArray();

        $this->typeOptions = SpaceType::orderBy('name')
            ->get(['id', 'name', 'code'])
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->code ? "[{$t->code}] {$t->name}" : $t->name])
            ->toArray();

        $this->modal = true;
    }

    public function updatedBuildingFilter(): void { $this->assignPage = 1; }
    public function updatedTypeFilter(): void     { $this->assignPage = 1; }
    public function updatedCapacityFilter(): void { $this->assignPage = 1; }

    public function assignPrev(): void { if ($this->assignPage > 1) $this->assignPage--; }
    public function assignNext(int $lastPage): void { if ($this->assignPage < $lastPage) $this->assignPage++; }

    public function assignedPrev(): void { if ($this->assignedPage > 1) $this->assignedPage--; }
    public function assignedNext(int $lastPage): void { if ($this->assignedPage < $lastPage) $this->assignedPage++; }

    public function selectSpace(int $spaceId): void
    {
        Activity::findOrFail($this->assignActivityId)->spaces()->attach($spaceId, ['assigned_by' => 'client']);
        $this->assignSpaceIds[] = $spaceId;
        $this->success('Space assigned.', position: 'toast-top toast-center');
        $this->dispatch('activity-spaces-changed');
    }

    public function removeSpace(int $spaceId): void
    {
        Activity::findOrFail($this->assignActivityId)->spaces()->detach($spaceId);
        $this->assignSpaceIds = array_values(array_filter($this->assignSpaceIds, fn($id) => $id !== $spaceId));
        $assignedPerPage = 10;
        $assignedTotal   = count($this->assignSpaceIds);
        $assignedLast    = $assignedTotal > 0 ? (int) ceil($assignedTotal / $assignedPerPage) : 1;
        if ($this->assignedPage > $assignedLast) $this->assignedPage = $assignedLast;
        $this->warning('Space removed.', position: 'toast-top toast-center');
        $this->dispatch('activity-spaces-changed');
    }

    public function removeAll(): void
    {
        RemoveAllSpacesFromActivityJob::dispatch($this->assignActivityId);
        $this->assignSpaceIds = [];
        $this->assignedPage   = 1;
        $this->warning('All spaces queued for removal.', position: 'toast-top toast-center');
        $this->dispatch('activity-spaces-changed');
    }

    public function selectAll(): void
    {
        $client = Client::where('user_id', auth()->id())->first();

        $newIds = Space::where('client_id', $client?->id)
            ->when($this->buildingFilter, fn($q) => $q->where('building_id', $this->buildingFilter))
            ->when($this->typeFilter,     fn($q) => $q->where('type_id', $this->typeFilter))
            ->when($this->capacityFilter, function ($q) {
                [$min, $max] = explode('-', $this->capacityFilter);
                $q->where('capacity', '>=', (int)$min)->where('capacity', '<=', (int)$max);
            })
            ->whereNotIn('id', $this->assignSpaceIds)
            ->pluck('id')->toArray();

        if (empty($newIds)) {
            $this->info('No new spaces to assign.', position: 'toast-top toast-center');
            return;
        }

        AssignSpacesToActivityJob::dispatch($this->assignActivityId, $newIds);
        $this->assignSpaceIds = array_merge($this->assignSpaceIds, $newIds);
        $this->success(count($newIds) . ' spaces queued for assignment.', position: 'toast-top toast-center');
        $this->dispatch('activity-spaces-changed');
    }

    public function with(): array
    {
        $client = Client::where('user_id', auth()->id())->first();
        $perPage = 10;

        $query = $this->modal
            ? Space::with(['building:id,name,code'])->withCount('activities')
                ->where('client_id', $client?->id)
                ->when($this->buildingFilter, fn($q) => $q->where('building_id', $this->buildingFilter))
                ->when($this->typeFilter,     fn($q) => $q->where('type_id', $this->typeFilter))
                ->when($this->capacityFilter, function ($q) {
                    [$min, $max] = explode('-', $this->capacityFilter);
                    $q->where('capacity', '>=', (int)$min)->where('capacity', '<=', (int)$max);
                })
                ->when($this->assignSpaceIds, fn($q) => $q->whereNotIn('id', $this->assignSpaceIds))
                ->orderBy('name')
            : null;

        $assignTotal  = $query?->count() ?? 0;
        $assignSpaces = $query
            ? $query->offset(($this->assignPage - 1) * $perPage)->limit($perPage)->get()
            : collect();
        $assignLastPage = $assignTotal > 0 ? (int) ceil($assignTotal / $perPage) : 1;

        $assignedTotal    = count($this->assignSpaceIds);
        $assignedLastPage = $assignedTotal > 0 ? (int) ceil($assignedTotal / $perPage) : 1;
        $assignedSpaces   = ($this->modal && $assignedTotal)
            ? Space::with('building:id,name')->withCount('activities')
                ->whereIn('id', $this->assignSpaceIds)->orderBy('name')
                ->offset(($this->assignedPage - 1) * $perPage)->limit($perPage)->get()
            : collect();

        return compact('assignSpaces', 'assignTotal', 'assignLastPage', 'assignedSpaces', 'assignedTotal', 'assignedLastPage');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Assign Space"
             separator class="modal-bottom" box-class="!max-w-[96rem] mx-auto !rounded-t-2xl !mb-14">
        <div class="grid grid-cols-2 gap-6">
            <div class="space-y-3">
                <div class="flex gap-2 flex-wrap">
                    <div class="flex-1 min-w-28">
                        <x-choices label="Building" single wire:model.live="buildingFilter"
                                   :options="$buildingOptions" placeholder="— All —" clearable />
                    </div>
                    <div class="flex-1 min-w-28">
                        <x-choices label="Type" single wire:model.live="typeFilter"
                                   :options="$typeOptions" placeholder="— All —" clearable />
                    </div>
                    <div class="flex-1 min-w-28">
                        <x-choices label="Capacity" single wire:model.live="capacityFilter"
                                   :options="$capacityOptions" placeholder="— All —" clearable />
                    </div>
                </div>

                <div class="overflow-hidden rounded-xl border border-base-200">
                    <table class="table table-sm table-zebra w-full">
                        <thead>
                            <tr class="text-base-content/60 text-xs bg-base-200/50">
                                <th class="w-6/12">Name</th>
                                <th class="w-3/12">Building</th>
                                <th class="w-1/12 text-right">Cap.</th>
                                <th class="w-1/12 text-right">Used</th>
                                <th class="w-8 text-right">
                                    <x-button icon="o-check-circle" class="btn-primary btn-xs btn-square"
                                              wire:click="selectAll" tooltip="Assign all filtered" />
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($assignSpaces as $space)
                            <tr wire:key="avail-{{ $space->id }}">
                                <td class="font-medium text-sm">{{ $space->name }}</td>
                                <td class="text-sm text-base-content/70">{{ $space->building?->name ?? '—' }}</td>
                                <td class="text-right text-sm">{{ $space->capacity ?? '—' }}</td>
                                <td class="text-right text-sm {{ $space->activities_count > 0 ? 'text-warning font-medium' : 'text-base-content/30' }}">
                                    {{ $space->activities_count }}
                                </td>
                                <td class="text-right">
                                    <x-button icon="o-check-circle" class="btn-primary btn-xs btn-square"
                                              wire:click="selectSpace({{ $space->id }})" tooltip="Assign" />
                                </td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="5" class="text-center text-sm text-base-content/40 py-6 italic">
                                    No spaces found.
                                </td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>

                @if($assignTotal > 10)
                <div class="flex items-center justify-between text-sm">
                    <span class="text-base-content/40 text-xs">{{ $assignTotal }} spaces</span>
                    <div class="join">
                        <x-button class="btn-xs join-item" icon="o-chevron-left"
                                  wire:click="assignPrev" :disabled="$assignPage <= 1" />
                        <span class="join-item btn btn-xs btn-ghost pointer-events-none">
                            {{ $assignPage }} / {{ $assignLastPage }}
                        </span>
                        <x-button class="btn-xs join-item" icon="o-chevron-right"
                                  wire:click="assignNext({{ $assignLastPage }})" :disabled="$assignPage >= $assignLastPage" />
                    </div>
                </div>
                @endif
            </div>

            <div class="space-y-3">
                <div class="bg-base-200/50 rounded-xl px-4 py-3 flex items-center justify-between gap-4">
                    <div class="min-w-0">
                        <p class="text-xs text-base-content/50 mb-0.5">Subject</p>
                        <p class="font-semibold text-sm truncate">
                            @if($subjectCode)<span class="text-base-content/50 font-normal mr-1">{{ $subjectCode }}</span>@endif{{ $subjectName }}
                        </p>
                    </div>
                    <div class="shrink-0 text-right">
                        <p class="text-xs text-base-content/50 mb-0.5">Total Students</p>
                        <p class="font-semibold text-sm">{{ $studentCount }}</p>
                    </div>
                </div>

                <div class="overflow-hidden rounded-xl border border-base-200">
                    <table class="table table-sm table-zebra w-full">
                        <thead>
                            <tr class="text-base-content/60 text-xs bg-base-200/50">
                                <th class="w-6/12">Name</th>
                                <th class="w-3/12">Building</th>
                                <th class="w-1/12 text-right">Cap.</th>
                                <th class="w-1/12 text-right">Used</th>
                                <th class="w-8 text-right">
                                    @if(count($assignSpaceIds))
                                    <x-button icon="o-x-circle" class="btn-error btn-xs btn-square btn-outline"
                                              wire:click="removeAll" tooltip="Remove all" />
                                    @endif
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($assignedSpaces as $space)
                            <tr wire:key="assn-{{ $space->id }}">
                                <td class="font-medium text-sm">{{ $space->name }}</td>
                                <td class="text-sm text-base-content/70">{{ $space->building?->name ?? '—' }}</td>
                                <td class="text-right text-sm">{{ $space->capacity ?? '—' }}</td>
                                <td class="text-right text-sm {{ $space->activities_count > 0 ? 'text-warning font-medium' : 'text-base-content/30' }}">
                                    {{ $space->activities_count }}
                                </td>
                                <td class="text-right">
                                    <x-button icon="o-x-circle" class="btn-error btn-xs btn-square btn-outline"
                                              wire:click="removeSpace({{ $space->id }})" tooltip="Remove" />
                                </td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="5" class="text-center text-sm text-base-content/40 py-6 italic">
                                    No space assigned.
                                </td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>

                @if($assignedTotal > 10)
                <div class="flex items-center justify-between text-sm">
                    <span class="text-base-content/40 text-xs">{{ $assignedTotal }} assigned</span>
                    <div class="join">
                        <x-button class="btn-xs join-item" icon="o-chevron-left"
                                  wire:click="assignedPrev" :disabled="$assignedPage <= 1" />
                        <span class="join-item btn btn-xs btn-ghost pointer-events-none">
                            {{ $assignedPage }} / {{ $assignedLastPage }}
                        </span>
                        <x-button class="btn-xs join-item" icon="o-chevron-right"
                                  wire:click="assignedNext({{ $assignedLastPage }})" :disabled="$assignedPage >= $assignedLastPage" />
                    </div>
                </div>
                @endif
            </div>
        </div>
    </x-modal>
</div>
