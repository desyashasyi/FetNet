<?php

use Livewire\Attributes\On;
use Livewire\Component;

new class extends Component
{
    public bool  $open  = false;
    public int   $count = 0;
    public array $items = [];

    #[On('open-compile-errors')]
    public function openWith(string $type, int $count, array $items): void
    {
        $this->count = $count;
        $this->items = $items;
        $this->open  = true;
    }
}; ?>

<div
    x-data="{ open: $wire.entangle('open') }"
    x-on:keydown.escape.window="open = false"
    class="relative z-50"
>
    {{-- Backdrop --}}
    <div
        x-show="open"
        x-transition:enter="transition ease-out duration-200"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        x-transition:leave="transition ease-in duration-150"
        x-transition:leave-start="opacity-100"
        x-transition:leave-end="opacity-0"
        class="fixed inset-0 bg-black/40"
        @click="open = false"
        x-cloak
    ></div>

    {{-- Bottom sheet panel --}}
    <div
        x-show="open"
        x-transition:enter="transition ease-out duration-300"
        x-transition:enter-start="translate-y-full opacity-0"
        x-transition:enter-end="translate-y-0 opacity-100"
        x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="translate-y-0 opacity-100"
        x-transition:leave-end="translate-y-full opacity-0"
        class="fixed bottom-0 left-1/2 -translate-x-1/2 z-50 w-full max-w-lg rounded-t-2xl bg-base-100 shadow-2xl flex flex-col max-h-[80vh]"
        x-cloak
    >
        {{-- Header --}}
        <div class="flex items-center justify-between px-6 pt-5 pb-4 border-b border-base-200 shrink-0">
            <div class="flex items-center gap-2">
                <x-icon name="o-exclamation-triangle" class="w-5 h-5 text-error" />
                <h3 class="font-semibold text-base">Incomplete Activities</h3>
            </div>
            <button @click="open = false" class="btn btn-ghost btn-sm btn-circle">
                <x-icon name="o-x-mark" class="w-4 h-4" />
            </button>
        </div>

        {{-- Body --}}
        <div class="px-6 py-4 overflow-y-auto flex-1">
            <p class="text-sm text-base-content/70 mb-4">
                <span class="font-semibold text-error">{{ $count }}</span>
                {{ $count === 1 ? 'activity is' : 'activities are' }} missing required data.
                Compile cancelled — complete the missing data on the <strong>Activities</strong> page, then compile again.
            </p>

            <table class="table table-sm w-full">
                <thead>
                    <tr class="text-xs text-base-content/50">
                        <th class="w-3/12">Code</th>
                        <th class="w-5/12">Subject</th>
                        <th class="w-4/12">Missing</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($items as $item)
                    <tr wire:key="ce-{{ $item['id'] }}" class="border-b border-base-200/60">
                        <td class="font-mono text-xs align-top py-2">{{ $item['code'] }}</td>
                        <td class="text-sm align-top py-2">{{ $item['name'] }}</td>
                        <td class="align-top py-2">
                            <div class="flex flex-col gap-0.5">
                                @foreach($item['issues'] as $issue)
                                    <x-badge :value="$issue" class="badge-error badge-sm badge-soft w-fit" />
                                @endforeach
                            </div>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>

        {{-- Footer --}}
        <div class="flex items-center justify-end gap-2 px-6 py-4 border-t border-base-200 shrink-0">
            <x-button label="Close" @click="open = false" />
            <x-button label="Go to Activities" icon="o-arrow-top-right-on-square"
                      class="btn-primary" link="{{ route('client.data.activities') }}" external />
        </div>
    </div>
</div>
