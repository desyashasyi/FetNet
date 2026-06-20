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
use Livewire\Livewire;
use Tests\TestCase;

class TimetableSlotDurationTest extends TestCase
{
    use RefreshDatabase;

    /** @return array{0:User,1:Semester,2:Activity,3:FetCompile} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2026, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'Subject One', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 3, 'active' => true]);
        $compile = FetCompile::create(['client_id' => $client->id, 'semester_id' => $sem->id, 'status' => 'success']);

        return [$user, $sem, $act, $compile];
    }

    public function test_solver_stores_the_activity_duration_on_the_slot(): void
    {
        [, , $act, $compile] = $this->scaffold();

        $this->app->bind(FetSolutionParser::class, fn () => new class($act->id) extends FetSolutionParser {
            public function __construct(private int $aid) {}
            public function parse(string $r, string $m, int $c): array
            {
                return [['activity_id' => $this->aid, 'day_index' => 1, 'hour_index' => 1, 'duration' => 3, 'room_id' => null]];
            }
        });

        $job    = new SolveTimetableJob($compile->id);
        $method = new \ReflectionMethod($job, 'upsertSlotsFromResult');
        $method->setAccessible(true);
        $method->invoke($job, $compile, 'x.fet');

        $this->assertSame(3, (int) TimetableSlot::where('activity_id', $act->id)->value('duration'));
    }

    public function test_grid_spans_a_multi_hour_slot_with_rowspan(): void
    {
        [$user, $sem, $act] = $this->scaffold();

        $client = Client::where('user_id', $user->id)->first();
        TimetableSlot::create([
            'client_id'   => $client->id,
            'semester_id' => $sem->id,
            'activity_id' => $act->id,
            'day_index'   => 1,
            'hour_index'  => 1,
            'duration'    => 3,
            'locked'      => false,
        ]);

        $html = Livewire::actingAs($user)->test('pages::client.timetable.view.idx', ['sem' => $sem->id])
            ->set('view', 'grid')->set('mode', 'grid')
            ->html();

        $this->assertStringContainsString('rowspan="3"', $html);
        $this->assertStringContainsString('Subject One', $html);
    }
}
