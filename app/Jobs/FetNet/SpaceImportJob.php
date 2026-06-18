<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\SpaceImportEvent;
use App\Imports\FetNet\SpaceImport;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Maatwebsite\Excel\Facades\Excel;
use Throwable;

/**
 * Queued job: import rooms from an uploaded spreadsheet (via SpaceImport) for a client,
 * then broadcast SpaceImportEvent with the imported/skipped counts. See
 * [[fetnet-job-events]].
 */
class SpaceImportJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 300;

    public function __construct(
        public string $filePath,
        public int    $clientId,
    ) {}

    /** Run the SpaceImport and broadcast a success summary. */
    public function handle(): void
    {
        $importer = new SpaceImport($this->clientId);
        Excel::import($importer, $this->filePath);

        $message = "Import done: {$importer->imported} imported, {$importer->skipped} skipped.";
        SpaceImportEvent::dispatch('success', $message);
    }

    /** On failure, broadcast an error event with the message. */
    public function failed(Throwable $e): void
    {
        SpaceImportEvent::dispatch('error', 'Import gagal: ' . $e->getMessage());
    }
}
