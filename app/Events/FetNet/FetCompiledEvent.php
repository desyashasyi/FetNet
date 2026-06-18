<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Broadcast (now) when a FET compile finishes, on channel `fet-compile.<clientId>` as
 * `.FetCompiledEvent`. Payload (broadcastWith): clientId, status (success|failed), path,
 * message, compile_id. The compile UI listens to enable/disable solving.
 */
class FetCompiledEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public int     $clientId,
        public ?string $path,
        public string  $status,    // 'success' | 'failed'
        public ?string $message    = null,
        public ?int    $compileId  = null,
    ) {}

    public function broadcastOn(): array
    {
        return [new Channel('fet-compile.' . $this->clientId)];
    }

    public function broadcastAs(): string
    {
        return 'FetCompiledEvent';
    }

    public function broadcastWith(): array
    {
        return [
            'clientId'   => $this->clientId,
            'status'     => $this->status,
            'path'       => $this->path,
            'message'    => $this->message,
            'compile_id' => $this->compileId,
        ];
    }
}
