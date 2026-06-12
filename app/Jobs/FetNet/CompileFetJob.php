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

            broadcast(new FetCompiledEvent(
                $this->clientId, $path, 'success', 'Compile completed.', $record->id
            ));
        } catch (Throwable $e) {
            $record->update([
                'status'      => 'failed',
                'message'     => $e->getMessage(),
                'duration_ms' => (int) ((hrtime(true) - $start) / 1_000_000),
            ]);

            broadcast(new FetCompiledEvent(
                $this->clientId, null, 'failed', $e->getMessage(), $record->id
            ));
        }
    }

    public function failed(Throwable $e): void
    {
        FetCompile::where('client_id', $this->clientId)
            ->where('semester_id', $this->semesterId)
            ->where('status', 'pending')
            ->orderByDesc('id')->limit(1)
            ->update(['status' => 'failed', 'message' => 'Worker crash: ' . $e->getMessage()]);

        broadcast(new FetCompiledEvent(
            $this->clientId, null, 'failed', 'Worker crash: ' . $e->getMessage()
        ));
    }
}
