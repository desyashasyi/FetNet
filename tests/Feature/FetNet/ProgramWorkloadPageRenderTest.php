<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProgramWorkloadPageRenderTest extends TestCase
{
    use RefreshDatabase;

    public function test_program_workload_page_renders_for_program_user(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);

        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $teacher = Teacher::create(['program_id' => $program->id, 'name' => 'Alice', 'code' => 'ALC']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'Intro', 'credit' => 3]);

        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 2, 'active' => true]);
        $activity->teachers()->attach($teacher->id);

        $response = $this->actingAs($user)->get('/program/data/workload');

        $response->assertOk();
        $response->assertSee('Lecturer Workload');
        $response->assertSee('Alice');
        $response->assertSee('CS'); // prodi column header
    }
}
