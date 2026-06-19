<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Space;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ActivitiesUnassignedSpaceFilterTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.data.activities.idx';

    /** @return array{0:User,1:Client,2:Program,3:Semester} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        return [$user, $client, $program, $sem];
    }

    private function makeActivity(Program $program, Semester $sem, bool $withSpace, Client $client): Activity
    {
        static $n = 0;
        $n++;
        $subject  = Subject::create(['program_id' => $program->id, 'code' => "TE10{$n}", 'name' => "Subject {$n}", 'credit' => 3]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);

        if ($withSpace) {
            $building = Building::firstOrCreate(['client_id' => $client->id, 'code' => 'A'], ['name' => 'Gedung A']);
            $space    = Space::create(['client_id' => $client->id, 'building_id' => $building->id, 'name' => "Room {$n}", 'capacity' => 30]);
            $activity->spaces()->attach($space->id, ['assigned_by' => 'client']);
        }

        return $activity;
    }

    public function test_sign_counts_activities_without_a_space_and_lists_the_programs(): void
    {
        [$user, $client, $program, $sem] = $this->scaffold();

        $this->makeActivity($program, $sem, withSpace: true,  client: $client);
        $this->makeActivity($program, $sem, withSpace: false, client: $client);
        $this->makeActivity($program, $sem, withSpace: false, client: $client);

        $component = Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id);

        // Two of the three activities have no space.
        $component->assertViewHas('unassignedTotal', 2);

        // The program shows up in the "needs space" picker with its count.
        $options = $component->viewData('unassignedProgramOptions');
        $this->assertCount(1, $options);
        $this->assertSame($program->id, $options[0]['id']);
        $this->assertStringContainsString('(2)', $options[0]['name']);
    }

    public function test_toggle_unassigned_limits_the_list_to_activities_without_a_space(): void
    {
        [$user, $client, $program, $sem] = $this->scaffold();

        $this->makeActivity($program, $sem, withSpace: true,  client: $client);
        $this->makeActivity($program, $sem, withSpace: false, client: $client);

        $component = Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id);

        $this->assertSame(2, $component->viewData('activities')->total());

        $component->call('toggleUnassigned')
            ->assertSet('unassignedOnly', true)
            ->assertSet('view', 'all');

        $this->assertSame(1, $component->viewData('activities')->total());
    }

    public function test_picking_a_program_filters_to_that_program_and_unassigned_only(): void
    {
        [$user, $client, $program, $sem] = $this->scaffold();

        Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id)
            ->set('unassignedProgramId', $program->id)
            ->assertSet('filterProgramId', $program->id)
            ->assertSet('unassignedOnly', true)
            ->assertSet('view', 'all');
    }
}
