<?php

use Livewire\Attributes\Reactive;
use Livewire\Component;

new class extends Component
{
    #[Reactive] public array  $rows           = [];
    #[Reactive] public bool   $showProgramCol = false;
    #[Reactive] public bool   $canAdd         = false;

    public function edit(int $id): void
    {
        $this->dispatch('open-constraint-edit', id: $id);
    }

    public function remove(int $id): void
    {
        $this->dispatch('constraint-delete-requested', id: $id);
    }
}; ?>

<div>
    <x-card>
        @if(empty($rows))
            <p class="text-center text-base-content/40 py-6 text-sm italic">
                No constraints set yet.@if($canAdd) Click <strong>Add</strong> to create one.@endif
            </p>
        @else
            <table class="table table-zebra table-sm w-full">
                <thead>
                    <tr class="border-b border-base-200">
                        <th class="text-left py-2 font-medium text-base-content/60 {{ $showProgramCol ? 'w-4/12' : 'w-5/12' }}">Teacher</th>
                        @if($showProgramCol)
                            <th class="text-left py-2 font-medium text-base-content/60 w-2/12">Program</th>
                        @endif
                        <th class="text-left py-2 font-medium text-base-content/60 w-3/12">Params</th>
                        <th class="text-center py-2 font-medium text-base-content/60 w-1/12">Value</th>
                        <th class="text-center py-2 font-medium text-base-content/60 w-1/12">Weight %</th>
                        <th class="w-1/12"></th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($rows as $row)
                        <tr wire:key="numrow-{{ $row['id'] }}" class="border-b border-base-100 hover:bg-base-300/40">
                            <td class="py-2">{{ $row['teacher'] }}</td>
                            @if($showProgramCol)
                                <td class="py-2 text-xs text-base-content/60">{{ $row['program_name'] ?? '—' }}</td>
                            @endif
                            <td class="py-2 text-base-content/60 text-xs">{{ $row['params'] ?: '—' }}</td>
                            <td class="py-2 text-center">
                                <x-badge value="{{ $row['value'] }}" class="badge-neutral badge-sm" />
                            </td>
                            <td class="py-2 text-center text-xs
                                       {{ $row['weight'] < 100 ? 'text-warning font-semibold' : 'text-base-content/40' }}">
                                {{ $row['weight'] }}%
                            </td>
                            <td class="py-2">
                                <div class="flex justify-end gap-1">
                                    <x-button icon="o-pencil" class="btn-ghost btn-xs btn-square"
                                              wire:click="edit({{ $row['id'] }})" tooltip="Edit" />
                                    <x-button icon="o-trash" class="btn-ghost btn-xs btn-square text-error"
                                              wire:click="remove({{ $row['id'] }})"
                                              wire:confirm="Remove this constraint?" tooltip="Delete" />
                                </div>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        @endif
    </x-card>
</div>
