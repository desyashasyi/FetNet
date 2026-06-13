<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class DeleteAllSubjectsTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.subjects.⚡idx';

    public function test_delete_all_removes_program_subjects_and_their_activities_only(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);

        $ay  = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        // Three subjects in the program; one has a planned activity (to verify cascade).
        $s1 = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'A', 'credit' => 3]);
        $s2 = Subject::create(['program_id' => $program->id, 'code' => 'CS102', 'name' => 'B', 'credit' => 3]);
        $s3 = Subject::create(['program_id' => $program->id, 'code' => 'CS103', 'name' => 'C', 'credit' => 3]);

        $planning = ActivityPlanning::create(['subject_id' => $s1->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 2, 'active' => true]);

        // Another program (different user) with its own subject — must remain untouched.
        $otherUser    = User::factory()->create();
        $otherProgram = Program::create(['client_id' => $client->id, 'user_id' => $otherUser->id, 'abbrev' => 'EE', 'name' => 'EE Program']);
        $otherSubject = Subject::create(['program_id' => $otherProgram->id, 'code' => 'EE201', 'name' => 'X', 'credit' => 2]);

        $this->assertSame(3, Subject::where('program_id', $program->id)->count());
        $this->assertSame(1, Activity::where('program_id', $program->id)->count());

        Livewire::actingAs($user)
            ->test(self::PAGE)
            ->call('confirmDeleteAll')
            ->assertSet('delAllModal', true)
            ->call('deleteAll')
            ->assertSet('delAllModal', false);

        // All program subjects + their activities gone.
        $this->assertSame(0, Subject::where('program_id', $program->id)->count());
        $this->assertSame(0, Activity::where('program_id', $program->id)->count());

        // Other program's data intact.
        $this->assertSame(1, Subject::where('program_id', $otherProgram->id)->count());
        $this->assertNotNull($otherSubject->fresh());
    }
}
