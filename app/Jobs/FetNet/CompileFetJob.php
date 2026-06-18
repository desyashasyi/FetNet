<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\FetCompiledEvent;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Semester;
use App\Services\FetNet\FetXmlBuilder;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Storage;
use Throwable;

/**
 * Queued job: build the FET solver input (.fet XML + activity-id map) for a client +
 * semester via FetXmlBuilder, persist it to local storage, and record the run in
 * FetCompile. Broadcasts FetCompiledEvent (success|failed). The compile is the
 * prerequisite for SolveTimetableJob. See [[fetnet-job-events]].
 */
class CompileFetJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 600;

    public function __construct(
        public int  $clientId,
        public int  $semesterId,
        public ?int $userId = null,
    ) {}

    /**
     * Create a pending FetCompile, build + store the .fet and .map.json, then mark the
     * record success (with size + duration) and broadcast; on error mark failed and
     * broadcast the message.
     */
    public function handle(FetXmlBuilder $builder): void
    {
        $start  = hrtime(true);
        $record = FetCompile::create([
            'client_id'   => $this->clientId,
            'semester_id' => $this->semesterId,
            'user_id'     => $this->userId,
            'status'      => 'pending',
        ]);

        try {
            $client   = Client::findOrFail($this->clientId);
            $semester = Semester::findOrFail($this->semesterId);

            $xml     = $builder->build($client, $semester);
            $path    = "fet/{$this->clientId}/sem{$this->semesterId}.fet";
            $mapPath = "fet/{$this->clientId}/sem{$this->semesterId}.map.json";
            Storage::disk('local')->put($path, $xml);
            Storage::disk('local')->put($mapPath, json_encode($builder->getActivityIdMap()));

            $record->update([
                'path'        => $path,
                'size_bytes'  => strlen($xml),
                'status'      => 'success',
                'duration_ms' => (int) ((hrtime(true) - $start) / 1_000_000),
                'message'     => 'Compile completed.',
            ]);

            try {
                broadcast(new FetCompiledEvent(
                    $this->clientId, $path, 'success', 'Compile completed.', $record->id
                ));
            } catch (Throwable) {
                // broadcast failure must not invalidate a successful compile
            }
        } catch (Throwable $e) {
            $record->update([
                'status'      => 'failed',
                'message'     => $e->getMessage(),
                'duration_ms' => (int) ((hrtime(true) - $start) / 1_000_000),
            ]);

            try {
                broadcast(new FetCompiledEvent(
                    $this->clientId, null, 'failed', $e->getMessage(), $record->id
                ));
            } catch (Throwable) {
                // broadcast failure must not mask the real compile error
            }
        }
    }

    /** On worker crash, mark the latest pending compile failed and broadcast. */
    public function failed(Throwable $e): void
    {
        FetCompile::where('client_id', $this->clientId)
            ->where('semester_id', $this->semesterId)
            ->where('status', 'pending')
            ->orderByDesc('id')->limit(1)
            ->update(['status' => 'failed', 'message' => 'Worker crash: ' . $e->getMessage()]);

        try {
            broadcast(new FetCompiledEvent(
                $this->clientId, null, 'failed', 'Worker crash: ' . $e->getMessage()
            ));
        } catch (Throwable) {
            // best-effort only
        }
    }
}
