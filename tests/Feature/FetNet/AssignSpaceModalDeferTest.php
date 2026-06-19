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
use App\Models\FetNet\SpaceType;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class AssignSpaceModalDeferTest extends TestCase
{
    use RefreshDatabase;

    private const IDX   = 'pages::client.data.activities.⚡idx';
    private const SHEET = 'pages::client.data.activities.assign-space-sheet';

    public function test_activities_default_view_is_all(): void
    {
        $user   = User::factory()->create();
        Client::create(['user_id' => $user->id]);

        Livewire::actingAs($user)->test(self::IDX)->assertSet('view', 'all');
    }

    public function test_assigning_one_space_does_not_emit_refresh_until_modal_closes(): void
    {
        $user     = User::factory()->create();
        $client   = Client::create(['user_id' => $user->id]);
        $program  = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $building = Building::create(['client_id' => $client->id, 'name' => 'Gedung A', 'code' => 'A']);
        $type     = SpaceType::create(['code' => 'LAB', 'name' => 'Laboratory', 'is_theory' => false]);
        $room     = Space::create(['client_id' => $client->id, 'building_id' => $building->id, 'type_id' => $type->id, 'name' => 'Lab 1', 'capacity' => 30]);

        $subject  = Subject::create(['program_id' => $program->id, 'code' => 'TE101', 'name' => 'Subject', 'credit' => 3]);
        $ay       = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem      = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);

        $sheet = Livewire::actingAs($user)->test(self::SHEET)->call('open', $activity->id);

        // Assigning a single room must NOT trigger the parent refresh (which would
        // re-render the parent and morph the bottom-slide modal shut).
        $sheet->call('selectSpace', $room->id)
              ->assertNotDispatched('activity-spaces-changed')
              ->assertSet('modal', true);

        // The deferred refresh fires once the modal is closed (via the X button).
        $sheet->set('modal', false)
              ->assertDispatched('activity-spaces-changed');

        $this->assertSame(1, $activity->fresh()->spaces()->count());
    }
}
