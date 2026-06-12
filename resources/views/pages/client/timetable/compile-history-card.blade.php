<?php

use App\Models\FetNet\FetCompile;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int $clientId   = null;
    #[Reactive] public ?int $semesterId = null;

    public function getListeners(): array
    {
        if (! $this->clientId) return [];
        return [
            'echo:fet-compile.' . $this->clientId . ',.FetCompiledEvent' => 'onCompiled',
        ];
    }

    public function onCompiled(array $payload): void
    {
        unset($this->compiles);
        if (($payload['status'] ?? '') === 'success') {
            $this->success('FET file ready. Download from the table below.', position: 'toast-top toast-center');
        } else {
            $this->error('Compile failed: ' . ($payload['message'] ?? 'unknown error'), position: 'toast-top toast-center');
        }
    }

    #[Computed]
    public function compiles()
    {
        if (! $this->clientId) return collect();
        return FetCompile::with(['semester:id,name,semester', 'user:id,name'])
            ->where('client_id', $this->clientId)
            ->when($this->semesterId, fn($q) => $q->where('semester_id', $this->semesterId))
            ->orderByDesc('id')->limit(20)->get();
    }

    #[Computed]
    public function latestSuccessIds()
    {
        if (! $this->clientId) return collect();
        return FetCompile::selectRaw('MAX(id) AS id, client_id, semester_id')
            ->where('client_id', $this->clientId)
            ->when($this->semesterId, fn($q) => $q->where('semester_id', $this->semesterId))
            ->where('status', 'success')
            ->groupBy('client_id', 'semester_id')
            ->pluck('id', 'semester_id');
    }

    public function isCurrent(\App\Models\FetNet\FetCompile $row): bool
    {
        return ($this->latestSuccessIds[$row->semester_id] ?? null) === $row->id;
    }

    public function downloadRoute(int $id): string
    {
        return route('client.timetable.download', $id);
    }
}; ?>

<div>
    <x-card title="Compile History" shadow separator>
        @if(count($this->compiles) === 0)
            <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                <x-icon name="o-archive-box" class="w-10 h-10" />
                <p class="text-sm">No compile runs yet for this semester.</p>
            </div>
        @else
            <div class="overflow-hidden">
                <table class="table table-sm table-zebra w-full">
                    <thead>
                        <tr class="text-base-content/60 text-xs">
                            <th class="w-2/12">Time</th>
                            <th class="w-2/12">Semester</th>
                            <th class="w-1/12 text-right">Size</th>
                            <th class="w-1/12 text-right">Duration</th>
                            <th class="w-2/12">Status</th>
                            <th class="w-3/12">By</th>
                            <th class="w-1/12 text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($this->compiles as $c)
                        <tr wire:key="compile-{{ $c->id }}" class="hover:bg-base-200/40">
                            <td class="text-sm">{{ $c->created_at->format('Y-m-d H:i') }}</td>
                            <td class="text-sm">
                                {{ $c->semester?->name ?: 'Sem ' . $c->semester?->semester }}
                            </td>
                            <td class="text-sm text-right">
                                {{ $c->size_bytes ? number_format($c->size_bytes / 1024, 1) . ' KB' : '—' }}
                            </td>
                            <td class="text-sm text-right">
                                {{ $c->duration_ms !== null ? number_format($c->duration_ms / 1000, 2) . ' s' : '—' }}
                            </td>
                            <td>
                                @if($c->status === 'success')
                                    <x-badge value="success" class="badge-success badge-sm" />
                                @elseif($c->status === 'failed')
                                    <x-badge value="failed" class="badge-error badge-sm" tooltip="{{ $c->message }}" />
                                @else
                                    <x-badge value="pending" class="badge-warning badge-sm" />
                                @endif
                            </td>
                            <td class="text-sm">{{ $c->user?->name ?? '—' }}</td>
                            <td class="text-right">
                                <div class="flex justify-end gap-1">
                                    @if($c->solver_status)
                                        <x-button icon="o-command-line" class="btn-ghost btn-xs btn-square"
                                                  wire:click="$dispatch('open-solver-log', { compileId: {{ $c->id }} })"
                                                  tooltip="View solver log" />
                                    @endif
                                    @if($c->status === 'success' && $c->path && $this->isCurrent($c))
                                        <x-button icon="o-arrow-down-tray" class="btn-ghost btn-xs btn-square"
                                                  :link="$this->downloadRoute($c->id)" external
                                                  tooltip="Download current file" />
                                    @elseif($c->status === 'success')
                                        <span class="text-xs text-base-content/40">replaced</span>
                                    @endif
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @endif
    </x-card>
</div>
