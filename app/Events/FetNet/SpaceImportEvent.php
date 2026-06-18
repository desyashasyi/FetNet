<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Broadcast (now) when a room import finishes, on channel `space-import` as
 * `.SpaceImportEvent`. Payload: status, message. The spaces UI listens to refresh + toast.
 */
class SpaceImportEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public string $status,
        public string $message,
    ) {}

    public function broadcastOn(): array
    {
        return [new Channel('space-import')];
    }

    public function broadcastAs(): string
    {
        return 'SpaceImportEvent';
    }
}
