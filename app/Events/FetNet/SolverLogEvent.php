<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SolverLogEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    /** @param array<int,string> $lines */
    public function __construct(
        public int $compileId,
        public array $lines,
    ) {}

    public function broadcastOn(): Channel
    {
        return new Channel('fet-solve.' . $this->compileId);
    }

    public function broadcastAs(): string
    {
        return 'SolverLogEvent';
    }

    public function broadcastWith(): array
    {
        return [
            'compile_id' => $this->compileId,
            'lines'      => $this->lines,
        ];
    }
}
