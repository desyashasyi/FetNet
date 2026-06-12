<?php

namespace App\Listeners;

use App\Events\FetNet\SolveTimetableRequestedEvent;
use App\Jobs\FetNet\SolveTimetableJob;
use App\Models\FetNet\FetCompile;

class SolveTimetableOnRequest
{
    public function handle(SolveTimetableRequestedEvent $event): void
    {
        $compile = FetCompile::find($event->compileId);
        if (! $compile) return;
        if ($compile->status !== 'success' || ! $compile->path) return;
        if ($compile->solver_status === 'running') return;

        SolveTimetableJob::dispatch($event->compileId, $event->userId);
    }
}
