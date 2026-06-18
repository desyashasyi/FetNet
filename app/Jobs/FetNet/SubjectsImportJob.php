<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\SubjectsImportEvent;
use App\Imports\FetNet\SubjectImport;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Maatwebsite\Excel\Facades\Excel;
use Throwable;

/**
 * Queued job: import subjects from an uploaded spreadsheet (via SubjectImport) for a
 * program, then broadcast SubjectsImportEvent with the imported/skipped counts. The
 * import is non-destructive (updateOrCreate keyed on code+program_id). See
 * [[fetnet-job-events]].
 */
class SubjectsImportJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 300;

    public function __construct(
        public string $filePath,
        public int    $programId,
    ) {}

    /** Run the SubjectImport and broadcast a success summary. */
    public function handle(): void
    {
        $importer = new SubjectImport($this->programId);
        Excel::import($importer, $this->filePath);

        SubjectsImportEvent::dispatch(
            'success',
            "Import done: {$importer->imported} imported, {$importer->skipped} skipped."
        );
    }

    /** On failure, broadcast an error event with the message. */
    public function failed(Throwable $e): void
    {
        SubjectsImportEvent::dispatch('error', 'Import failed: ' . $e->getMessage());
    }
}
