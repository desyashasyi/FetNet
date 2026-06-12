<?php

namespace App\Events\FetNet;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CompileFetRequestedEvent
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public int  $clientId,
        public int  $semesterId,
        public ?int $userId = null,
    ) {}
}
