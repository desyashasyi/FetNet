<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class ActivitySpacesUpdatedEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public int    $activityId,
        public string $status,
        public string $message,
    ) {}

    public function broadcastOn(): array
    {
        return [new Channel('activity-spaces')];
    }

    public function broadcastAs(): string
    {
        return 'ActivitySpacesUpdatedEvent';
    }
}
