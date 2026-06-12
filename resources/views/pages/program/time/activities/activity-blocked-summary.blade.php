<?php

use Livewire\Component;
use Mary\Traits\Toast;
use App\Models\FetNet\ActivityTimeConstraint;

new class extends Component
{
    use Toast;

    public array $rows         = [];
    public array $dayLabels    = [];
    public array $slotLabels   = [];
    public int   $numberOfDays = 0;

    public function edit(int $id): void
    {
        $this->dispatch('open-activity-edit', activityId: $id);
    }

    public function clearBlocked(int $id): void
    {
        ActivityTimeConstraint::where('activity_id', $id)->delete();
        $this->warning('Not available periods cleared.', position: 'toast-top toast-center');
        $this->dispatch('activity-blocked-changed');
    }
}; ?>

<div>
    <x-card>
        @if(empty($rows))
            <p class="text-center text-base-content/40 py-8 text-sm italic">
                No activity time constraints set for this semester.
                Click <strong>Add</strong> to define not-available slots.
            </p>
        @else
            <table class="table table-zebra table-sm w-full">
                <thead>
                    <tr class="border-b border-base-200">
                        <th class="text-left py-2 font-medium text-base-content/60 w-8/12">Activity</th>
                        <th class="text-center py-2 font-medium text-base-content/60 w-2/12">Blocked Slots</th>
                        <th class="w-2/12"></th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($rows as $row)
                        <tr wire:key="actrow-{{ $row['id'] }}" class="border-b border-base-100 hover:bg-base-300/40">
                            <td class="py-2">
                                <div class="font-medium text-xs">{{ $row['subject'] }}</div>
                                <div class="text-base-content/50 text-xs">{{ $row['detail'] }}</div>
                            </td>
                            <td class="py-2 text-center">
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
                            </td>
                            <td class="py-2 text-right">
                                <div class="flex justify-end gap-1">
                                    <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                              wire:click="edit({{ $row['id'] }})" tooltip="Edit" />
                                    <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                              wire:click="clearBlocked({{ $row['id'] }})"
                                              wire:confirm="Clear all blocked slots for this activity?"
                                              tooltip="Clear" />
                                </div>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        @endif
    </x-card>
</div>
