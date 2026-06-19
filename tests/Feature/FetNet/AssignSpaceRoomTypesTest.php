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

class AssignSpaceRoomTypesTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.data.activities.assign-space-sheet';

    public function test_assign_space_lists_all_room_types_including_theory(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $building = Building::create(['client_id' => $client->id, 'name' => 'Gedung A', 'code' => 'A']);

        // One theory type (e.g. Classroom) and one non-theory type (Lab).
        $theory = SpaceType::create(['code' => 'CLS', 'name' => 'Classroom',  'is_theory' => true]);
        $lab    = SpaceType::create(['code' => 'LAB', 'name' => 'Laboratory', 'is_theory' => false]);

        Space::create(['client_id' => $client->id, 'building_id' => $building->id, 'type_id' => $theory->id, 'name' => 'Ruang Teori 1', 'capacity' => 40]);
        Space::create(['client_id' => $client->id, 'building_id' => $building->id, 'type_id' => $lab->id,    'name' => 'Lab Elektronika', 'capacity' => 30]);

        // Minimal planned activity to open the sheet against.
        $subject  = Subject::create(['program_id' => $program->id, 'code' => 'TE101', 'name' => 'Subject', 'credit' => 3]);
        $ay       = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem      = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);

        $component = Livewire::actingAs($user)->test(self::PAGE)->call('open', $activity->id);

        // Both the theory room and the lab room must be listed as assignable.
        $component->assertSee('Ruang Teori 1')
                  ->assertSee('Lab Elektronika');

        // The Type filter must offer the theory type too, not just non-theory ones.
        $typeNames = collect($component->get('typeOptions'))->pluck('name')->implode(' | ');
        $this->assertStringContainsString('Classroom', $typeNames, 'theory type missing from filter');
        $this->assertStringContainsString('Laboratory', $typeNames);
    }
}
