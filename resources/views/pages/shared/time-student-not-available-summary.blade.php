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

    public function edit(int $studentId): void
    {
        $this->dispatch('open-not-available-edit', studentId: $studentId);
    }
}; ?>

<div>
    <x-card>
        @if(empty($rows))
            <p class="text-center text-base-content/40 py-6 text-sm italic">
                No not-available constraints set yet.
            </p>
        @else
            <table class="table table-zebra table-sm w-full">
                <thead>
                    <tr class="border-b border-base-200">
                        @if($showProgramCol)
                            <th class="text-left py-2 font-medium text-base-content/60 w-2/12">Program</th>
                        @endif
                        <th class="text-left py-2 font-medium text-base-content/60 {{ $showProgramCol ? 'w-5/12' : 'w-7/12' }}">Group</th>
                        <th class="text-center py-2 font-medium text-base-content/60 w-2/12">Blocked Slots</th>
                        <th class="text-center py-2 font-medium text-base-content/60 w-2/12">Weight %</th>
                        <th class="w-auto"></th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($rows as $row)
                        <tr wire:key="snarow-{{ $row['id'] }}" class="border-b border-base-100 hover:bg-base-300/40">
                            @if($showProgramCol)
                                <td class="py-2 text-xs text-base-content/60">{{ $row['program_name'] ?? '—' }}</td>
                            @endif
                            <td class="py-2">{{ $row['student'] }}</td>
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
        @endif
    </x-card>
</div>
