<?php

namespace App\Events\FetNet;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SolveTimetableRequestedEvent
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public int $compileId,
        public ?int $userId = null,
        public int $timeLimitSeconds = 600,
    ) {}
}
