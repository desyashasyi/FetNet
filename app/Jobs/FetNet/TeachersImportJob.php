<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\TeachersImportEvent;
use App\Imports\FetNet\TeacherImport;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Maatwebsite\Excel\Facades\Excel;
use Throwable;

/**
 * Queued job: import lecturers from an uploaded spreadsheet (via TeacherImport) for a
 * program. Resolves a cluster-aware abbrev→program_id map so a row naming another
 * cluster program's lecturer can be attached as a guest. Broadcasts TeachersImportEvent
 * summarising imported / added-as-guest / skipped counts and any auto-generated codes.
 * See [[fetnet-job-events]].
 */
class TeachersImportJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 300;

    public function __construct(
        public string $filePath,
        public int    $programId,
    ) {}

    /**
     * Build the cluster abbrev→id map, run TeacherImport, then broadcast a summary
     * (imported / guests / skipped, plus any auto-generated lecturer codes).
     */
    public function handle(): void
    {
        // Build cluster-aware program map: lowercase abbrev => program_id
        $clusterEntry = Cluster::where('program_id', $this->programId)->first();

        $programIds = $clusterEntry
            ? Cluster::where('cluster_base_id', $clusterEntry->cluster_base_id)
                ->pluck('program_id')
                ->toArray()
            : [$this->programId];

        $programMap = Program::whereIn('id', $programIds)->get(['id', 'abbrev'])
            ->mapWithKeys(fn($p) => [strtolower($p->abbrev) => $p->id])
            ->toArray();

        $importer = new TeacherImport($programMap, $this->programId);
        Excel::import($importer, $this->filePath);

        $parts   = ["imported: {$importer->imported}"];
        if ($importer->asGuest  > 0) $parts[] = "added as guest: {$importer->asGuest}";
        if ($importer->skipped  > 0) $parts[] = "skipped: {$importer->skipped}";
        $message = 'Import done — ' . implode(', ', $parts) . '.';

        if (count($importer->codeAutoGen) > 0) {
            $codes    = implode(', ', $importer->codeAutoGen);
            $message .= " Auto-generated codes: {$codes}.";
        }

        TeachersImportEvent::dispatch('success', $message);
    }

    /** On failure, broadcast an error event with the message. */
    public function failed(Throwable $e): void
    {
        TeachersImportEvent::dispatch('error', 'Import gagal: ' . $e->getMessage());
    }
}
