<?php

use App\Models\FetNet\Client;
use Livewire\Attributes\Layout;
use Livewire\Component;

new #[Layout('layouts.client')] class extends Component
{
    public function with(): array
    {
        return [
            'client' => Client::with(['university', 'faculty'])->where('user_id', auth()->id())->first(),
        ];
    }
}; ?>

<div>
    <x-header title="Basic Data" subtitle="Basic configuration for the study program" separator />

    @if($client)
        <div class="space-y-6">

            <x-card title="Institution Info" shadow separator>
                <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                    <x-input label="University"  value="{{ $client->university?->code }} | {{ $client->university?->name }}" readonly />
                    <x-input label="Faculty"     value="{{ $client->faculty?->code }} | {{ $client->faculty?->name }}" readonly />
                    <x-input label="Description" value="{{ $client->description }}" readonly class="md:col-span-2" />
                </div>
            </x-card>

            <x-card title="Academic Year & Semester" shadow separator>
                <p class="text-sm text-base-content/60 mb-3">Configure academic years and semesters from the dedicated page.</p>
                <x-button label="Manage Academic Years" icon="o-calendar-days" class="btn-primary btn-sm"
                          link="{{ route('client.data.academic-year') }}" wire:navigate />
            </x-card>

            <livewire:pages::client.data.basic.schedule-config-card />

        </div>
    @else
        <x-alert icon="o-exclamation-triangle" class="alert-warning">
            This account is not registered as a client. Please contact the Super Admin.
        </x-alert>
    @endif
</div>
