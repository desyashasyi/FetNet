<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Component;

/**
 * Lecturer workload table (shared by the client + program workload pages). Each program
 * column and the Total column show the lecturer's load as "Pengampu 1 - Pengampu 2 (sum)"
 * (e.g. 23-5 (28)). The P1 and P2 numbers hover to reveal the contributing subjects +
 * classes (like the not-available constraint summaries); the combined total in parentheses
 * is plain text with no hover.
 */
new class extends Component
{
    /** Client context (client workload page); used when no programId is set. */
    public ?int $clientId = null;
    /** Program filter / program workload page; scopes the recap to that program. */
    public ?int $programId = null;
    /** Active semester whose period the recap covers. */
    public ?int $semesterId = null;

    /** Current lecturer page (1-based). The table paginates lecturers 10 per page. */
    public int $page = 1;

    private const PER_PAGE = 10;

    public function prevPage(): void { if ($this->page > 1) $this->page--; }
    public function nextPage(int $lastPage): void { if ($this->page < $lastPage) $this->page++; }

    /**
     * Build the recap here (rather than receiving it as a prop) so the data always reaches
     * the table — passing the large, deeply nested report array across the Livewire
     * component boundary dropped it. A programId scopes to everyone teaching in that program
     * (guests included); otherwise the whole client is recapped.
     *
     * @return array{programs:array,rows:array}
     */
    private function report(): array
    {
        $service = app(LecturerWorkloadReport::class);

        if ($this->programId) {
            $program = Program::find($this->programId);
            return $program ? $service->forProgram($program, $this->semesterId) : ['programs' => [], 'rows' => []];
        }

        $client = $this->clientId ? Client::find($this->clientId) : null;
        return $client ? $service->forClient($client, $this->semesterId) : ['programs' => [], 'rows' => []];
    }

    /**
     * Flatten each row into a uniform list of cells (one per program, then Total) so the
     * template can render every "P1-P2" hover cell with the same markup, then slice the
     * lecturer rows to the current page (10 per page).
     */
    public function with(): array
    {
        ['programs' => $programs, 'rows' => $rows] = $this->report();

        $empty = ['p1' => 0, 'p2' => 0, 'p1Detail' => [], 'p2Detail' => []];

        $allRows = array_map(function ($r) use ($empty, $programs) {
            $cells = array_map(
                fn ($p) => $r['perProgram'][$p['id']] ?? $empty,
                $programs,
            );
            $cells[] = $r['total'];

            return [
                'lecturer' => $r['name'] . ($r['code'] ? " ({$r['code']})" : ''),
                'cells'    => $cells,
            ];
        }, $rows);

        $total     = count($allRows);
        $lastPage  = $total > 0 ? (int) ceil($total / self::PER_PAGE) : 1;
        $page      = max(1, min($this->page, $lastPage));
        $tableRows = array_slice($allRows, ($page - 1) * self::PER_PAGE, self::PER_PAGE);

        return compact('programs', 'tableRows', 'total', 'lastPage', 'page');
    }
}; ?>

<div>
<x-card>
    {{-- No overflow wrapper here: an overflow-x container also clips overflow-y (per the
         CSS spec), which would hide the hover popover that escapes the cell. The table is
         w-full so it fits; very wide tables fall back to page-level horizontal scroll. --}}
    <div>
        <table class="table table-zebra w-full">
            <thead>
                <tr class="border-b border-base-200">
                    <th class="text-left py-2 font-medium text-base-content/60">Lecturer</th>
                    @foreach($programs as $p)
                        <th class="text-center py-2 font-medium text-base-content/60">{{ $p['abbrev'] }}</th>
                    @endforeach
                    <th class="text-center py-2 font-bold text-base-content/70">Total</th>
                </tr>
            </thead>
            <tbody>
                @forelse($tableRows as $tr)
                    <tr class="border-b border-base-100 hover:bg-base-300/30">
                        <td class="py-2 whitespace-nowrap">{{ $tr['lecturer'] }}</td>
                        @foreach($tr['cells'] as $cell)
                            <td class="py-2 text-center {{ $loop->last ? 'font-semibold' : '' }}">
                                <div class="inline-flex items-center justify-center gap-0.5">
                                    @foreach([
                                        ['v' => $cell['p1'], 'd' => $cell['p1Detail'], 'role' => 'Pengampu 1', 'cls' => 'text-primary'],
                                        ['v' => $cell['p2'], 'd' => $cell['p2Detail'], 'role' => 'Pengampu 2', 'cls' => 'text-secondary'],
                                    ] as $i => $n)
                                        @if($i > 0)<span class="text-base-content/30">-</span>@endif

                                        @if($n['v'] > 0 && count($n['d']))
                                            <div x-data="{ above: false }"
                                                 @mouseenter="above = $el.getBoundingClientRect().top < window.innerHeight / 2"
                                                 :class="above ? 'dropdown-bottom' : 'dropdown-top'"
                                                 class="dropdown dropdown-hover dropdown-center inline-block">
                                                <div tabindex="0" role="button">
                                                    <span class="cursor-pointer font-semibold {{ $n['cls'] }}">{{ $n['v'] }}</span>
                                                </div>
                                                <div tabindex="0"
                                                     class="dropdown-content z-50 shadow-lg bg-base-100 border border-base-300 rounded-box p-2 mb-1 text-left min-w-max">
                                                    <p class="text-[10px] font-semibold uppercase tracking-wide {{ $n['cls'] }} mb-1">
                                                        {{ $n['role'] }} · {{ count($n['d']) }} kelas · {{ $n['v'] }} SKS
                                                    </p>
                                                    <div class="space-y-0.5">
                                                        @foreach($n['d'] as $d)
                                                            <div class="text-xs whitespace-nowrap">
                                                                <span class="font-mono font-semibold">{{ $d['code'] ?? '?' }}</span>
                                                                <span>{{ $d['name'] }}</span>
                                                                <span class="text-base-content/50">
                                                                    — {{ count($d['classes']) ? implode(', ', $d['classes']) : 'tanpa kelas' }}
                                                                </span>
                                                                @if(! empty($d['co']))
                                                                    <span class="text-secondary">· tandem: {{ implode(', ', $d['co']) }}</span>
                                                                @endif
                                                            </div>
                                                        @endforeach
                                                    </div>
                                                </div>
                                            </div>
                                        @else
                                            <span class="{{ $n['v'] > 0 ? $n['cls'] : 'text-base-content/20' }}">{{ $n['v'] }}</span>
                                        @endif
                                    @endforeach

                                    {{-- Combined total (P1+P2), plain text, no hover. --}}
                                    <span class="text-base-content/40 ml-1">({{ $cell['p1'] + $cell['p2'] }})</span>
                                </div>
                            </td>
                        @endforeach
                    </tr>
                @empty
                    <tr>
                        <td colspan="{{ count($programs) + 2 }}" class="text-center text-base-content/40 py-6 text-sm italic">
                            No lecturer workload found.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($lastPage > 1)
        <div class="flex items-center justify-between mt-3">
            <span class="text-sm text-base-content/40">{{ $total }} lecturers</span>
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
