<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Broadcast (now) when a lecturer import finishes, on channel `teachers-import` as
 * `.TeachersImportEvent`. Payload: status, message. The teachers UI listens to refresh + toast.
 */
class TeachersImportEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public string $status,
        public string $message,
    ) {}

    public function broadcastOn(): array
    {
        return [new Channel('teachers-import')];
    }

    public function broadcastAs(): string
    {
        return 'TeachersImportEvent';
    }
}
