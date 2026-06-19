<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\ActivityType;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\SpaceType;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class AssignSpaceDefaultTypeTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::client.data.activities.assign-space-sheet';

    private function makeActivity(Client $client, Program $program, ActivityType $type): Activity
    {
        $ay       = AcademicYear::firstOrCreate(['client_id' => $client->id, 'year_start' => 2024], ['is_active' => true]);
        $sem      = Semester::firstOrCreate(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1], ['name' => 'Odd']);
        $subject  = Subject::create(['program_id' => $program->id, 'code' => 'S'.$type->id, 'name' => 'Subj', 'credit' => 3]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);

        return Activity::create([
            'program_id'  => $program->id,
            'planning_id' => $planning->id,
            'type_id'     => $type->id,
            'duration'    => 3,
            'active'      => true,
        ]);
    }

    public function test_default_room_type_follows_the_activity_type(): void
    {
        $user      = User::factory()->create();
        $client    = Client::create(['user_id' => $user->id]);
        $program   = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        // Use the existing lookup rows (seeded) or create them if absent — avoids
        // creating duplicate "Classroom"/"Laboratory" types that would skew the match.
        $classroom = SpaceType::firstOrCreate(['name' => 'Classroom'],  ['code' => 'CLS', 'is_theory' => true]);
        $lab       = SpaceType::firstOrCreate(['name' => 'Laboratory'], ['code' => 'LAB', 'is_theory' => false]);

        $theoryType = ActivityType::firstOrCreate(['name' => 'Theory']);
        $labType    = ActivityType::firstOrCreate(['name' => 'Laboratory']);

        $theoryAct = $this->makeActivity($client, $program, $theoryType);
        $labAct    = $this->makeActivity($client, $program, $labType);

        // Theory class -> Classroom space type.
        Livewire::actingAs($user)->test(self::SHEET)
            ->call('open', $theoryAct->id)
            ->assertSet('typeFilter', $classroom->id);

        // Laboratory class -> Laboratory space type.
        Livewire::actingAs($user)->test(self::SHEET)
            ->call('open', $labAct->id)
            ->assertSet('typeFilter', $lab->id);
    }
}
