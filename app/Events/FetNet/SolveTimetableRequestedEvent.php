<?php

namespace App\Events\FetNet;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Internal (non-broadcast) request to start the solver for a compiled input. A listener
 * turns this into a queued SolveTimetableJob. Carries compileId, userId, and a
 * timeLimitSeconds hint.
 */
class SolveTimetableRequestedEvent
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public int $compileId,
        public ?int $userId = null,
        public int $timeLimitSeconds = 600,
    ) {}
}
