<?php

use Livewire\Attributes\Reactive;
use Livewire\Component;

new class extends Component
{
    #[Reactive] public array $rows           = [];
    #[Reactive] public array $dayLabels      = [];
    #[Reactive] public array $slotLabels     = [];
    #[Reactive] public int   $numberOfDays   = 0;
    #[Reactive] public bool  $showProgramCol = false;
    #[Reactive] public bool  $canEdit        = false;

    /** Current page for the in-memory teacher pager (10 per page). */
    public int $page = 1;

    /** Live teacher-name search, owned by the parent page (rendered in its filter row). */
    #[Reactive] public string $search = '';

    private const PER_PAGE = 10;

    public function prevPage(): void { if ($this->page > 1) $this->page--; }
    public function nextPage(int $lastPage): void { if ($this->page < $lastPage) $this->page++; }

    public function edit(int $teacherId): void
    {
        $this->dispatch('open-not-available-edit', teacherId: $teacherId);
    }

    /** Filter by name, sort alphabetically, and slice to the current page (10 per page). */
    public function with(): array
    {
        $term = mb_strtolower(trim($this->search));

        $sorted = collect($this->rows)
            ->when($term !== '', fn($c) => $c->filter(
                fn($r) => str_contains(mb_strtolower($r['teacher'] ?? ''), $term)
            ))
            ->sortBy(fn($r) => mb_strtolower($r['teacher'] ?? ''), SORT_NATURAL)
            ->values();

        $total    = $sorted->count();
        $lastPage = $total > 0 ? (int) ceil($total / self::PER_PAGE) : 1;
        $page     = max(1, min($this->page, $lastPage));
        $pageRows = $sorted->slice(($page - 1) * self::PER_PAGE, self::PER_PAGE)->values()->all();

        return compact('pageRows', 'total', 'lastPage', 'page');
    }
}; ?>

<div>
    <x-card>
        <table class="table table-zebra table-sm w-full">
            <thead>
                <tr class="border-b border-base-200">
                    <th class="text-left py-2 font-medium text-base-content/60 {{ $showProgramCol ? 'w-5/12' : 'w-7/12' }}">Teacher</th>
                    @if($showProgramCol)
                        <th class="text-left py-2 font-medium text-base-content/60 w-2/12">Program</th>
                    @endif
                    <th class="text-center py-2 font-medium text-base-content/60 w-2/12">Blocked slots</th>
                    <th class="text-center py-2 font-medium text-base-content/60 w-2/12">Weight %</th>
                    <th class="w-auto"></th>
                </tr>
            </thead>
            <tbody>
                @foreach($pageRows as $row)
                    <tr wire:key="narow-{{ $row['id'] }}" class="border-b border-base-100 hover:bg-base-300/40">
                        <td class="py-2">{{ $row['teacher'] }}</td>
                        @if($showProgramCol)
                            <td class="py-2 text-xs text-base-content/60">{{ $row['program_name'] ?? '—' }}</td>
                        @endif
                        <td class="py-2 text-center">
                            @if($row['slots'] > 0)
                                <div x-data="{ above: false }"
                                     @mouseenter="above = $el.getBoundingClientRect().top < window.innerHeight / 2"
                                     :class="above ? 'dropdown-bottom' : 'dropdown-top'"
                                     class="dropdown dropdown-hover dropdown-center inline-block">
                                    <div tabindex="0" role="button">
                                        <x-badge value="{{ $row['slots'] }}" class="badge-error badge-sm cursor-pointer" />
                                    </div>
                                    <div tabindex="0" class="dropdown-content z-50 shadow-lg bg-base-100 border border-base-300 rounded-box p-2 mb-1">
                                        <table class="border-collapse text-xs">
                                            <thead>
                                                <tr>
                                                    <th class="pr-1 pb-0.5"></th>
                                                    @foreach($dayLabels as $dayLabel)
                                                        <th class="px-0.5 pb-0.5 font-semibold text-center text-base-content/60 w-6">
                                                            {{ substr($dayLabel, 0, 1) }}
                                                        </th>
                                                    @endforeach
                                                </tr>
                                            </thead>
                                            <tbody>
                                                @foreach($slotLabels as $entry)
                                                    @php $h = $entry['idx']; @endphp
                                                    @if($entry['break'])
                                                        <tr>
                                                            <td class="pr-1 py-0.5 text-right font-mono text-base-content/40 whitespace-nowrap">
                                                                {{ explode('–', $entry['time'])[0] }}
                                                            </td>
                                                            @for($d = 1; $d <= $numberOfDays; $d++)
                                                                <td class="px-0.5 py-0.5">
                                                                    <div class="w-5 h-4 rounded-sm {{ isset($row['blockedMap']["{$d}-{$h}"]) ? 'bg-success/60' : 'bg-error/30' }}"></div>
                                                                </td>
                                                            @endfor
                                                        </tr>
                                                    @else
                                                        <tr>
                                                            <td class="pr-1 py-0.5 text-right font-mono text-base-content/40 whitespace-nowrap">
                                                                {{ explode('–', $entry['time'])[0] }}
                                                            </td>
                                                            @for($d = 1; $d <= $numberOfDays; $d++)
                                                                <td class="px-0.5 py-0.5">
                                                                    <div class="w-5 h-4 rounded-sm {{ isset($row['blockedMap']["{$d}-{$h}"]) ? 'bg-error/70' : 'bg-base-200' }}"></div>
                                                                </td>
                                                            @endfor
                                                        </tr>
                                                    @endif
                                                @endforeach
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            @else
                                <span class="text-base-content/30 text-xs">—</span>
                            @endif
                        </td>
                        <td class="py-2 text-center text-xs
                                   {{ $row['slots'] > 0 && $row['weight'] < 100 ? 'text-warning font-semibold' : 'text-base-content/30' }}">
                            {{ $row['slots'] > 0 ? $row['weight'].'%' : '—' }}
                        </td>
                        <td class="py-2 text-right">
                            @if($canEdit)
                                <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                          wire:click="edit({{ $row['id'] }})" tooltip="Edit" />
                            @endif
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        @if($lastPage > 1)
            <div class="flex items-center justify-between mt-3">
                <span class="text-sm text-base-content/40">{{ $total }} teachers</span>
                <div class="join">
                    <x-button class="btn-sm join-item" icon="o-chevron-left"
                              wire:click="prevPage" :disabled="$page <= 1" />
                    <span class="join-item btn btn-sm btn-ghost pointer-events-none">{{ $page }} / {{ $lastPage }}</span>
                    <x-button class="btn-sm join-item" icon="o-chevron-right"
                              wire:click="nextPage({{ $lastPage }})" :disabled="$page >= $lastPage" />
                </div>
            </div>
        @endif
    </x-card>
</div>
