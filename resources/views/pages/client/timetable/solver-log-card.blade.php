<?php

use App\Models\FetNet\FetCompile;
use App\Services\FetNet\FetReportReader;
use Illuminate\Support\Facades\Storage;
use Livewire\Attributes\Computed;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public ?int    $compileId    = null;
    public bool    $open         = false;

    public array   $lines         = [];
    public ?string $status        = null;
    public ?string $resultPath    = null;
    public ?string $statusMessage = null;

    public function getListeners(): array
    {
        $base = [
            'open-solver-log' => 'openFor',
        ];
        if (! $this->compileId) return $base;
        $ch = 'fet-solve.' . $this->compileId;
        return $base + [
            "echo:{$ch},.SolverLogEvent"      => 'onLog',
            "echo:{$ch},.SolverFinishedEvent" => 'onFinished',
        ];
    }

    public function openFor(int $compileId): void
    {
        $this->compileId     = $compileId;
        $this->lines         = [];
        $this->status        = null;
        $this->resultPath    = null;
        $this->statusMessage = null;
        $this->loadStateFromDb();
        if (! $this->status) $this->status = 'queued';
        unset($this->report);
        $this->open = true;
    }

    public function close(): void
    {
        $this->open = false;
    }

    public function refresh(): void
    {
        if (! $this->compileId || ! $this->open) return;
        $this->loadStateFromDb();
        unset($this->report);
    }

    private function compile(): ?FetCompile
    {
        return $this->compileId ? FetCompile::find($this->compileId) : null;
    }

    private function loadStateFromDb(): void
    {
        $c = $this->compile();
        if (! $c) return;
        $this->status        = $c->solver_status;
        $this->resultPath    = $c->solver_result_path;
        $this->statusMessage = $c->solver_message;

        if ($c->solver_output_dir) {
            $logAbs = Storage::disk('local')->path($c->solver_output_dir . '/solver.log');
            if (is_file($logAbs)) {
                $content = @file_get_contents($logAbs);
                if ($content !== false) {
                    $lines = preg_split('/\R/', $content) ?: [];
                    $lines = array_values(array_filter($lines, fn($l) => $l !== ''));
                    $this->lines = array_slice($lines, -500);
                }
            }
        }
    }

    public function onLog(array $payload): void
    {
        foreach ($payload['lines'] ?? [] as $l) {
            $this->lines[] = $l;
        }
        if (count($this->lines) > 500) {
            $this->lines = array_slice($this->lines, -500);
        }
        if ($this->status !== 'running') $this->status = 'running';
    }

    public function onFinished(array $payload): void
    {
        $this->status        = $payload['status']      ?? 'failed';
        $this->resultPath    = $payload['result_path'] ?? null;
        $this->statusMessage = $payload['message']     ?? null;
        unset($this->report);

        match ($this->status) {
            'success' => $this->success('Timetable generated.', position: 'toast-top toast-center'),
            'stopped' => $this->warning('Solver stopped.',       position: 'toast-top toast-center'),
            default   => $this->error('Solver failed: ' . ($this->statusMessage ?? 'unknown'), position: 'toast-top toast-center'),
        };
    }

    public function stop(): void
    {
        $c = $this->compile();
        if (! $c || $c->solver_status !== 'running' || ! $c->solver_pid) return;
        $c->update(['solver_status' => 'stopping']);
        @posix_kill($c->solver_pid, SIGTERM);
        $this->status = 'stopping';
        $this->info('Stop signal sent. Solver will save current state and exit.', position: 'toast-top toast-center');
    }


    #[Computed]
    public function report(): array
    {
        $c = $this->compile();
        if (! $c || ! $c->solver_output_dir) {
            return ['issues' => [], 'warnings' => [], 'placed_count' => 0, 'placed' => [], 'unplaced' => [], 'summary' => [], 'result' => ''];
        }
        return app(FetReportReader::class)
            ->read($c->solver_output_dir, $c->client_id, $c->semester_id, $c->solver_result_path);
    }
}; ?>

<div>
    <x-modal wire:model="open"
             title="Solver Log"
             subtitle="Live output from fet-cl"
             box-class="!max-w-5xl"
             persistent>

        @if(! in_array($status, ['success', 'failed', 'stopped'], true))
            <div wire:poll.1500ms="refresh" class="hidden"></div>
        @endif

        <div class="flex flex-wrap items-center gap-2 mb-3">
            @if($status === 'running')
                <x-badge value="running" class="badge-warning badge-sm animate-pulse" />
            @elseif($status === 'queued')
                <x-badge value="queued" class="badge-info badge-sm animate-pulse" />
            @elseif($status === 'stopping')
                <x-badge value="stopping" class="badge-warning badge-sm" />
            @elseif($status === 'success')
                <x-badge value="success" class="badge-success badge-sm" />
            @elseif($status === 'stopped')
                <x-badge value="stopped" class="badge-warning badge-sm" />
            @elseif($status === 'failed')
                <x-badge value="failed" class="badge-error badge-sm" />
            @elseif($status)
                <x-badge :value="$status" class="badge-neutral badge-sm" />
            @endif

            <span class="text-xs text-base-content/60">
                {{ count($lines) }} log line{{ count($lines) === 1 ? '' : 's' }}
            </span>

            <div class="grow"></div>

            @if($status === 'running')
                <x-button label="Stop" icon="o-stop-circle"
                          class="btn-error btn-sm" wire:click="stop"
                          wire:confirm="Stop solver? Current best timetable will be saved." />
            @endif
        </div>

        @php($report = $this->report)
        @php($totalActivities = (int) ($report['summary']['activities'] ?? 0))
        @php($placedCount = (int) ($report['placed_count'] ?? 0))

        @if($totalActivities > 0)
            <div class="flex items-center gap-3 mb-3 px-3 py-2 rounded-md bg-base-200">
                <x-icon name="o-chart-bar" class="w-5 h-5 text-base-content/60" />
                <div class="text-sm">
                    Placed
                    <span class="font-semibold text-success">{{ $placedCount }}</span>
                    /
                    <span class="font-semibold">{{ $totalActivities }}</span>
                    activities
                    @if($totalActivities > 0)
                        <span class="text-xs text-base-content/50">
                            ({{ number_format($placedCount * 100 / $totalActivities, 1) }}%)
                        </span>
                    @endif
                </div>
                <progress class="progress progress-success w-full max-w-md"
                          value="{{ $placedCount }}" max="{{ $totalActivities }}"></progress>
            </div>
        @endif

        <x-tabs selected="log-tab">
            <x-tab name="log-tab"
                   label="Live Log"
                   icon="o-command-line">
                <div
                    x-data="{
                        init() {
                            this.scroll();
                            this.$watch('$wire.lines', () => this.$nextTick(() => this.scroll()));
                        },
                        scroll() {
                            const el = this.$refs.log;
                            if (el) el.scrollTop = el.scrollHeight;
                        }
                    }"
                >
                    <pre x-ref="log"
                         class="font-mono text-xs leading-snug bg-base-300 text-base-content rounded-md p-3 h-[28rem] overflow-y-auto whitespace-pre-wrap break-words">@if(empty($lines))<span class="text-base-content/40">Waiting for solver output…</span>@else
{!! e(implode("\n", $lines)) !!}
@endif</pre>
                </div>
            </x-tab>

            <x-tab name="issues-tab"
                   label="Issues ({{ count($report['issues']) }})"
                   icon="o-exclamation-triangle">
                @if(empty($report['issues']))
                    <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                        <x-icon name="o-check-circle" class="w-10 h-10 text-success" />
                        <p class="text-sm">No blocking issues reported.</p>
                    </div>
                @else
                    <div class="overflow-y-auto max-h-[28rem]">
                        <table class="table table-sm table-zebra w-full">
                            <thead>
                                <tr class="text-base-content/60 text-xs">
                                    <th class="w-12">FET&nbsp;Id</th>
                                    <th class="w-16">DB&nbsp;Id</th>
                                    <th class="w-1/12">Subject</th>
                                    <th class="w-2/12">Teacher</th>
                                    <th class="w-2/12">Students</th>
                                    <th>Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($report['issues'] as $i)
                                    <tr class="align-top">
                                        <td class="text-xs font-mono">{{ $i['emit_id'] ?? '—' }}</td>
                                        <td class="text-xs font-mono">{{ $i['activity_id'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $i['subject'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $i['teacher'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $i['students'] ?? '—' }}</td>
                                        <td class="text-xs text-error">{{ $i['message'] }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @endif
            </x-tab>

            <x-tab name="placed-tab"
                   label="Placed ({{ count($report['placed']) }})"
                   icon="o-check-badge">
                @if(empty($report['placed']))
                    <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                        <x-icon name="o-archive-box" class="w-10 h-10" />
                        <p class="text-sm">No activities placed yet.</p>
                    </div>
                @else
                    <div class="overflow-y-auto max-h-[28rem]">
                        <table class="table table-sm table-zebra w-full">
                            <thead>
                                <tr class="text-base-content/60 text-xs">
                                    <th class="w-12">FET&nbsp;Id</th>
                                    <th class="w-16">DB&nbsp;Id</th>
                                    <th class="w-1/12">Subject</th>
                                    <th class="w-2/12">Teacher</th>
                                    <th>Students</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($report['placed'] as $p)
                                    <tr>
                                        <td class="text-xs font-mono">{{ $p['emit_id'] }}</td>
                                        <td class="text-xs font-mono">{{ $p['activity_id'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $p['subject'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $p['teacher'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $p['students'] ?? '—' }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @endif
            </x-tab>

            <x-tab name="unplaced-tab"
                   label="Unplaced ({{ count($report['unplaced']) }})"
                   icon="o-x-circle">
                @if(empty($report['unplaced']))
                    <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                        <x-icon name="o-check-circle" class="w-10 h-10 text-success" />
                        <p class="text-sm">All activities placed.</p>
                    </div>
                @else
                    <div class="overflow-y-auto max-h-[28rem]">
                        <table class="table table-sm table-zebra w-full">
                            <thead>
                                <tr class="text-base-content/60 text-xs">
                                    <th class="w-12">FET&nbsp;Id</th>
                                    <th class="w-16">DB&nbsp;Id</th>
                                    <th class="w-1/12">Subject</th>
                                    <th class="w-1/12">Teacher</th>
                                    <th class="w-2/12">Students</th>
                                    <th>Why not placed</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($report['unplaced'] as $u)
                                    <tr class="align-top">
                                        <td class="text-xs font-mono">{{ $u['emit_id'] }}</td>
                                        <td class="text-xs font-mono">{{ $u['activity_id'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $u['subject'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $u['teacher'] ?? '—' }}</td>
                                        <td class="text-xs">{{ $u['students'] ?? '—' }}</td>
                                        <td class="text-xs text-error">{{ $u['reason'] ?? '—' }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @endif
            </x-tab>

            <x-tab name="summary-tab"
                   label="Summary"
                   icon="o-document-text">
                @if(empty($report['summary']) && empty($report['warnings']) && ! $report['result'])
                    <div class="flex flex-col items-center py-10 text-base-content/40 gap-2">
                        <x-icon name="o-document-text" class="w-10 h-10" />
                        <p class="text-sm">No summary available.</p>
                    </div>
                @else
                    @if(! empty($report['summary']))
                        <h4 class="text-xs font-semibold text-base-content/60 mb-2 uppercase tracking-wide">Loaded data</h4>
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 mb-4">
                            @foreach($report['summary'] as $label => $count)
                                <div class="bg-base-200 rounded-md px-3 py-2">
                                    <div class="text-xs text-base-content/60">{{ ucfirst($label) }}</div>
                                    <div class="text-lg font-semibold">{{ $count }}</div>
                                </div>
                            @endforeach
                        </div>
                    @endif

                    @if($report['result'])
                        <h4 class="text-xs font-semibold text-base-content/60 mb-2 uppercase tracking-wide">Result</h4>
                        <pre class="font-mono text-xs bg-base-300 rounded-md p-3 mb-4 whitespace-pre-wrap">{{ $report['result'] }}</pre>
                    @endif

                    @if(! empty($report['warnings']))
                        <h4 class="text-xs font-semibold text-base-content/60 mb-2 uppercase tracking-wide">Warnings</h4>
                        <div class="space-y-2 max-h-64 overflow-y-auto">
                            @foreach($report['warnings'] as $w)
                                <div class="text-xs bg-warning/10 text-base-content rounded-md p-2 whitespace-pre-wrap">{{ $w }}</div>
                            @endforeach
                        </div>
                    @endif
                @endif
            </x-tab>
        </x-tabs>

        @if($statusMessage)
            <p class="text-xs text-base-content/60 mt-2">{{ $statusMessage }}</p>
        @endif

        <x-slot:actions>
            <x-button label="Close" wire:click="close" />
        </x-slot:actions>
    </x-modal>
</div>
