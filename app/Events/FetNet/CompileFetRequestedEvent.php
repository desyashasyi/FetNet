<?php

namespace App\Events\FetNet;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Internal (non-broadcast) request to compile FET input for a client + semester. A
 * listener turns this into a queued CompileFetJob. Carries clientId, semesterId, userId.
 */
class CompileFetRequestedEvent
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public int  $clientId,
        public int  $semesterId,
        public ?int $userId = null,
    ) {}
}
