<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Broadcast (now) when the solver run ends, on channel `fet-solve.<compileId>` as
 * `.SolverFinishedEvent`. Payload (broadcastWith): compile_id, status
 * (success|failed|stopped), message, result_path. The solve UI listens to show the
 * outcome and load the timetable.
 */
class SolverFinishedEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public int $compileId,
        public string $status,         // success | failed | stopped
        public ?string $message = null,
        public ?string $resultPath = null,
    ) {}

    public function broadcastOn(): Channel
    {
        return new Channel('fet-solve.' . $this->compileId);
    }

    public function broadcastAs(): string
    {
        return 'SolverFinishedEvent';
    }

    public function broadcastWith(): array
    {
        return [
            'compile_id'  => $this->compileId,
            'status'      => $this->status,
            'message'     => $this->message,
            'result_path' => $this->resultPath,
        ];
    }
}
