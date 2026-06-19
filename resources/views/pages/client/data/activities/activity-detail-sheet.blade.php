<?php

use App\Models\FetNet\Activity;
use Livewire\Attributes\On;
use Livewire\Component;

new class extends Component
{
    public bool  $modal      = false;
    public array $detailData = [];
    public int   $spacePage  = 1;

    private const SPACES_PER_PAGE = 5;

    #[On('open-activity-detail')]
    public function open(int $activityId): void
    {
        $activity = Activity::with(['planning.subject', 'type', 'teachers', 'students', 'spaces.building', 'tags'])
            ->findOrFail($activityId);

        $this->spacePage = 1;

        $this->detailData = [
            'subject'  => trim(($activity->planning?->subject?->code ?? '') . ' — ' . ($activity->planning?->subject?->name ?? ''), ' — '),
            'type'     => $activity->type?->name ?? '—',
            'duration' => $activity->duration,
            'active'   => $activity->active,
            'teachers' => $activity->teachers->map(fn($t) => $t->code . ($t->name ? ' — ' . $t->name : ''))->toArray(),
            'groups'   => $activity->students->pluck('name')->toArray(),
            'spaces'   => $activity->spaces->map(fn($s) => [
                'name'     => $s->name,
                'building' => $s->building?->name ?? '—',
                'capacity' => $s->capacity,
            ])->toArray(),
            'tags'     => $activity->tags->pluck('name')->toArray(),
            'note'     => $activity->note ?? '',
        ];

        $this->modal = true;
    }

    /** In-memory pager for the assigned-rooms list (5 per page). */
    public function spacePrev(): void { if ($this->spacePage > 1) $this->spacePage--; }
    public function spaceNext(int $lastPage): void { if ($this->spacePage < $lastPage) $this->spacePage++; }

    /** Slice the assigned rooms to the current page and expose the plotted count. */
    public function with(): array
    {
        $spaces    = $this->detailData['spaces'] ?? [];
        $spaceTotal = count($spaces);
        $perPage   = self::SPACES_PER_PAGE;
        $lastPage  = max(1, (int) ceil($spaceTotal / $perPage));
        $pageSpaces = array_slice($spaces, ($this->spacePage - 1) * $perPage, $perPage);

        return compact('spaceTotal', 'lastPage', 'pageSpaces');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Activity Detail"
             separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        @if($detailData)
        <div class="space-y-3 text-sm">
            <div>
                <p class="text-xs text-base-content/50 mb-0.5">Subject</p>
                <p class="font-semibold">{{ $detailData['subject'] ?? '—' }}</p>
            </div>
            {{-- Type, Duration, Status, Teachers and Student Groups share one info row. --}}
            <div class="flex gap-x-6 gap-y-3 flex-wrap items-start">
                <div>
                    <p class="text-xs text-base-content/50 mb-0.5">Type</p>
                    <p>{{ $detailData['type'] }}</p>
                </div>
                <div>
                    <p class="text-xs text-base-content/50 mb-0.5">Duration</p>
                    <p>{{ $detailData['duration'] }} min</p>
                </div>
                <div>
                    <p class="text-xs text-base-content/50 mb-0.5">Status</p>
                    @if($detailData['active'])
                        <x-badge value="Active" class="badge-success badge-sm" />
                    @else
                        <x-badge value="Inactive" class="badge-ghost badge-sm" />
                    @endif
                </div>
                <div>
                    <p class="text-xs text-base-content/50 mb-0.5">Teachers</p>
                    @if(count($detailData['teachers']))
                        <div class="flex flex-wrap gap-1">
                            @foreach($detailData['teachers'] as $t)
                                <x-badge value="{{ $t }}" class="badge-neutral badge-sm" />
                            @endforeach
                        </div>
                    @else
                        <span class="text-base-content/30 italic">—</span>
                    @endif
                </div>
                <div>
                    <p class="text-xs text-base-content/50 mb-0.5">Student Groups</p>
                    @if(count($detailData['groups']))
                        <div class="flex flex-wrap gap-1">
                            @foreach($detailData['groups'] as $g)
                                <x-badge value="{{ $g }}" class="badge-info badge-sm" />
                            @endforeach
                        </div>
                    @else
                        <span class="text-base-content/30 italic">—</span>
                    @endif
                </div>
            </div>
            <div>
                <div class="flex items-center justify-between mb-1">
                    <p class="text-xs text-base-content/50">
                        Spaces — <span class="font-semibold text-base-content">{{ $spaceTotal }}</span> ruangan diplot
                    </p>
                    @if($lastPage > 1)
                    <div class="join">
                        <x-button class="btn-xs join-item" icon="o-chevron-left"
                                  wire:click="spacePrev" :disabled="$spacePage <= 1" />
                        <span class="join-item btn btn-xs btn-ghost pointer-events-none">{{ $spacePage }} / {{ $lastPage }}</span>
                        <x-button class="btn-xs join-item" icon="o-chevron-right"
                                  wire:click="spaceNext({{ $lastPage }})" :disabled="$spacePage >= $lastPage" />
                    </div>
                    @endif
                </div>
                @if($spaceTotal)
                    <div class="space-y-1.5">
                        @foreach($pageSpaces as $s)
                        <div class="bg-base-200/50 rounded-lg p-2.5 space-y-0.5">
                            <p class="font-medium text-sm">{{ $s['name'] }}</p>
                            <div class="flex gap-4 text-xs text-base-content/60">
                                <span>Building: <span class="text-base-content">{{ $s['building'] }}</span></span>
                                @if($s['capacity'])
                                <span>Cap.: <span class="text-base-content">{{ $s['capacity'] }}</span></span>
                                @endif
                            </div>
                        </div>
                        @endforeach
                    </div>
                @else
                    <span class="text-base-content/30 italic">No spaces assigned</span>
                @endif
            </div>
            @if(count($detailData['tags']))
            <div>
                <p class="text-xs text-base-content/50 mb-0.5">Tags</p>
                <div class="flex flex-wrap gap-1">
                    @foreach($detailData['tags'] as $tag)
                        <x-badge value="{{ $tag }}" class="badge-ghost badge-sm" />
                    @endforeach
                </div>
            </div>
            @endif
            @if($detailData['note'])
            <div>
                <p class="text-xs text-base-content/50 mb-0.5">Note</p>
                <p class="text-base-content/70">{{ $detailData['note'] }}</p>
            </div>
            @endif
        </div>
        @endif
    </x-modal>
</div>
