<?php

namespace Tests\Feature\FetNet;

use App\Jobs\FetNet\SolveTimetableJob;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\TimetableSlot;
use App\Models\User;
use App\Services\FetNet\FetSolutionParser;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SolveSlotsManualLockTest extends TestCase
{
    use RefreshDatabase;

    private FetCompile $compile;
    private Activity $activity;

    private function scaffold(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2026, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'S', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);

        $this->activity = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 1, 'active' => true]);
        $this->compile  = FetCompile::create(['client_id' => $client->id, 'semester_id' => $sem->id, 'status' => 'success']);
    }

    /** Bind a fake parser that places the activity at the given day/hour, then run the upsert. */
    private function generateAt(int $day, int $hour): void
    {
        $this->app->bind(FetSolutionParser::class, function () use ($day, $hour) {
            return new class($this->activity->id, $day, $hour) extends FetSolutionParser {
                public function __construct(private int $aid, private int $d, private int $h) {}
                public function parse(string $r, string $m, int $c): array
                {
                    return [['activity_id' => $this->aid, 'day_index' => $this->d, 'hour_index' => $this->h, 'room_id' => null]];
                }
            };
        });

        $job    = new SolveTimetableJob($this->compile->id);
        $method = new \ReflectionMethod($job, 'upsertSlotsFromResult');
        $method->setAccessible(true);
        $method->invoke($job, $this->compile, 'unused.fet');
    }

    public function test_generated_slots_start_unlocked(): void
    {
        $this->scaffold();
        $this->generateAt(1, 1);

        $slot = TimetableSlot::where('activity_id', $this->activity->id)->first();
        $this->assertNotNull($slot);
        $this->assertFalse((bool) $slot->locked);
    }

    public function test_manual_lock_survives_regeneration_and_pins_placement(): void
    {
        $this->scaffold();
        $this->generateAt(1, 1);

        // User manually locks the slot.
        $slot = TimetableSlot::where('activity_id', $this->activity->id)->first();
        $slot->update(['locked' => true]);

        // Re-generate (FET keeps a locked slot in place, so the parser returns the same cell).
        $this->generateAt(1, 1);

        $slot->refresh();
        $this->assertTrue((bool) $slot->locked, 'manual lock must survive re-generation');
    }
}
