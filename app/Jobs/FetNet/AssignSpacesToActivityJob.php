<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\ActivitySpacesUpdatedEvent;
use App\Models\FetNet\Activity;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

/**
 * Queued job: attach a set of rooms to an activity (without detaching existing ones),
 * then broadcast ActivitySpacesUpdatedEvent so the activities UI refreshes. See
 * [[fetnet-job-events]] for the job→event pattern.
 */
class AssignSpacesToActivityJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 60;

    /** @param int[] $spaceIds Room ids to assign to the activity. */
    public function __construct(
        public int   $activityId,
        public array $spaceIds,
    ) {}

    /** Sync-without-detach the rooms and broadcast a success event. */
    public function handle(): void
    {
        Activity::find($this->activityId)?->spaces()->syncWithoutDetaching($this->spaceIds);

        ActivitySpacesUpdatedEvent::dispatch(
            $this->activityId,
            'success',
            count($this->spaceIds) . ' space(s) assigned.',
        );
    }
}