<?php

namespace App\Listeners;

use App\Events\FetNet\CompileFetRequestedEvent;
use App\Jobs\FetNet\CompileFetJob;
use App\Models\FetNet\FetCompile;

class CompileFetOnRequest
{
    public function handle(CompileFetRequestedEvent $event): void
    {
        $hasPending = FetCompile::where('client_id', $event->clientId)
            ->where('semester_id', $event->semesterId)
            ->where('status', 'pending')
            ->exists();

        if ($hasPending) return;

        CompileFetJob::dispatch($event->clientId, $event->semesterId, $event->userId);
    }
}
