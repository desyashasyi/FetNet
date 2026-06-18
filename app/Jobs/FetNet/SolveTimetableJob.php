<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\SolverFinishedEvent;
use App\Events\FetNet\SolverLogEvent;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\TimetableSlot;
use App\Services\FetNet\FetSolutionParser;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\Process\Process;
use Throwable;

/**
 * Long-running queued job (on the `timetable` queue): runs the external `fet-cl` solver
 * against a successful FetCompile's input file, streaming its stdout/stderr to the
 * frontend as SolverLogEvent batches, and periodically requesting intermediate snapshots
 * via the fet-cl "sigwrite" file. On finish it parses the result, upserts TimetableSlot
 * rows, updates the compile's solver_* fields, and broadcasts SolverFinishedEvent.
 *
 * No timeout: the solver runs until success, impossibility, or a user Stop (SIGTERM,
 * detected via solver_status='stopping'). See [[fetnet-job-events]].
 */
class SolveTimetableJob implements ShouldQueue
{
    use Queueable;

    public int $tries = 1;
    // Effectively unbounded — solver runs until success, impossibility, or SIGTERM.
    public int $timeout = 0;

    private const FLUSH_INTERVAL_SECONDS = 0.25;

    public function __construct(
        public int  $compileId,
        public ?int $userId = null,
    ) {
        $this->onQueue('timetable');
    }

    /**
     * Launch fet-cl, stream its output live (batched broadcasts), poll for completion
     * while interleaving sigwrite snapshot requests, then persist slots + final status
     * and broadcast SolverFinishedEvent. No-op if the compile isn't a successful build.
     */
    public function handle(): void
    {
        $compile = FetCompile::find($this->compileId);
        if (! $compile || $compile->status !== 'success' || ! $compile->path) {
            return;
        }

        $inputAbs  = Storage::disk('local')->path($compile->path);
        $outputRel = "fet-solve/{$compile->id}";
        Storage::disk('local')->makeDirectory($outputRel);
        $outputAbs = Storage::disk('local')->path($outputRel);

        $binary = env('FET_CL_PATH', 'fet-cl');
        // No --timelimitseconds: fet-cl default is effectively infinite (~2e9 s).
        // No Process timeout either — Stop button sends SIGTERM for graceful exit.
        $process = new Process([
            $binary,
            '--inputfile=' . $inputAbs,
            '--outputdir=' . $outputAbs,
            '--verbose=true',
            '--language=en_US',
        ]);
        $process->setTimeout(null);
        $process->setIdleTimeout(null);

        try {
            $process->start();
        } catch (Throwable $e) {
            $compile->update([
                'solver_status'  => 'failed',
                'solver_message' => 'Failed to start fet-cl: ' . $e->getMessage(),
            ]);
            try {
                broadcast(new SolverFinishedEvent($this->compileId, 'failed', $e->getMessage()));
            } catch (Throwable) {}
            return;
        }

        $compile->update([
            'solver_status'     => 'running',
            'solver_output_dir' => $outputRel,
            'solver_started_at' => now(),
            'solver_pid'        => $process->getPid(),
            'solver_message'    => null,
        ]);

        $logHandle = @fopen("{$outputAbs}/solver.log", 'a');
        $buffer    = [];
        $lastFlush     = microtime(true);
        $lastSigwrite  = microtime(true);
        $sigwritePath  = "{$outputAbs}/sigwrite";
        $sigwriteEvery = 3.0; // seconds between forced snapshots

        $flush = function (bool $force = false) use (&$buffer, &$lastFlush) {
            if (empty($buffer)) return;
            $now = microtime(true);
            if (! $force && ($now - $lastFlush) < self::FLUSH_INTERVAL_SECONDS) return;
            try {
                broadcast(new SolverLogEvent($this->compileId, $buffer));
            } catch (Throwable) {}
            $buffer    = [];
            $lastFlush = $now;
        };

        $consumeChunk = function (string $chunk) use (&$buffer, $logHandle, $flush) {
            if ($chunk === '') return;
            if ($logHandle) @fwrite($logHandle, $chunk);
            foreach (preg_split('/\R/', rtrim($chunk, "\r\n")) as $line) {
                if ($line === '') continue;
                $buffer[] = $line;
                if (count($buffer) >= 50) $flush(true);
            }
            $flush();
        };

        // Manual polling loop so we can interleave sigwrite snapshots with
        // incremental stdout reads. fet-cl checks for the sigwrite file once
        // per second and, when found, removes it and dumps the current /
        // highest-stage timetable without stopping the generation.
        while ($process->isRunning()) {
            $consumeChunk($process->getIncrementalOutput());
            $consumeChunk($process->getIncrementalErrorOutput());

            $now = microtime(true);
            if (! file_exists($sigwritePath) && ($now - $lastSigwrite) >= $sigwriteEvery) {
                @touch($sigwritePath);
                $lastSigwrite = $now;
            }

            usleep(200_000);
        }
        // Drain anything left after exit.
        $consumeChunk($process->getIncrementalOutput());
        $consumeChunk($process->getIncrementalErrorOutput());
        $flush(true);
        if ($logHandle) @fclose($logHandle);

        $exitCode = $process->getExitCode();
        $stopped  = $compile->fresh()->solver_status === 'stopping';

        $resultPath = $this->locateResultFile($outputRel, $compile->path);

        $status  = $stopped ? 'stopped' : ($exitCode === 0 ? 'success' : 'failed');
        $message = $stopped
            ? 'Solver stopped by user.'
            : ($exitCode === 0 ? 'Solver finished.' : 'Solver exited with code ' . $exitCode);

        if ($resultPath && ($status === 'success' || $status === 'stopped')) {
            $this->upsertSlotsFromResult($compile, $resultPath);
        }

        $compile->update([
            'solver_status'      => $status,
            'solver_finished_at' => now(),
            'solver_pid'         => null,
            'solver_result_path' => $resultPath,
            'solver_message'     => $message,
        ]);

        try {
            broadcast(new SolverFinishedEvent($this->compileId, $status, $message, $resultPath));
        } catch (Throwable) {}
    }

    /**
     * Parse the solver's result .fet (via FetSolutionParser + the activity-id map) and
     * upsert one locked TimetableSlot per placed activity for this client + semester.
     */
    private function upsertSlotsFromResult(FetCompile $compile, string $resultRel): void
    {
        $mapRel = "fet/{$compile->client_id}/sem{$compile->semester_id}.map.json";

        $parsed = app(FetSolutionParser::class)->parse($resultRel, $mapRel, $compile->client_id);
        if (empty($parsed)) return;

        foreach ($parsed as $row) {
            TimetableSlot::updateOrCreate(
                [
                    'client_id'   => $compile->client_id,
                    'semester_id' => $compile->semester_id,
                    'activity_id' => $row['activity_id'],
                ],
                [
                    'day_index'      => $row['day_index'],
                    'hour_index'     => $row['hour_index'],
                    'room_id'        => $row['room_id'],
                    'locked'         => true,
                    'weight_percent' => 100,
                ],
            );
        }
    }

    /** Find the solver's "<base>_data_and_timetable.fet" output, or null if absent. */
    private function locateResultFile(string $outputRel, string $inputRel): ?string
    {
        $base = pathinfo($inputRel, PATHINFO_FILENAME);
        $disk = Storage::disk('local');

        $candidates = [
            "{$outputRel}/timetables/{$base}/{$base}_data_and_timetable.fet",
        ];
        foreach ($candidates as $rel) {
            if ($disk->exists($rel)) return $rel;
        }

        $hits = glob($disk->path("{$outputRel}/timetables/{$base}") . '/*_data_and_timetable.fet');
        if ($hits) {
            return "{$outputRel}/timetables/{$base}/" . basename($hits[0]);
        }
        return null;
    }

    /** On worker crash, mark the compile's solver failed and broadcast. */
    public function failed(Throwable $e): void
    {
        $compile = FetCompile::find($this->compileId);
        if (! $compile) return;
        $compile->update([
            'solver_status'      => 'failed',
            'solver_message'     => 'Worker crash: ' . $e->getMessage(),
            'solver_finished_at' => now(),
            'solver_pid'         => null,
        ]);
        try {
            broadcast(new SolverFinishedEvent($this->compileId, 'failed', 'Worker crash: ' . $e->getMessage()));
        } catch (Throwable) {}
    }
}
