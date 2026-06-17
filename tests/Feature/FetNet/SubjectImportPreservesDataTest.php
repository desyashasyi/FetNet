<?php

namespace Tests\Feature\FetNet;

use App\Imports\FetNet\SubjectImport;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Student;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Collection;
use Tests\TestCase;

class SubjectImportPreservesDataTest extends TestCase
{
    use RefreshDatabase;

    public function test_importing_subjects_does_not_delete_teachers_students_or_activities(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);

        $ay  = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        $teacher = Teacher::create(['program_id' => $program->id, 'name' => 'Alice', 'code' => 'ALC']);
        $batch   = Student::create(['program_id' => $program->id, 'name' => '2024']);
        $group   = Student::create(['program_id' => $program->id, 'name' => 'CS-A', 'parent_id' => $batch->id]);

        // Existing subject already used by an activity.
        $existing = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'Algorithms', 'credit' => 3, 'semester' => 1]);
        $planning = ActivityPlanning::create(['subject_id' => $existing->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);
        $activity->teachers()->attach($teacher->id);
        $activity->students()->attach($group->id);

        // Import: one row updating the existing subject, one new subject.
        $rows = new Collection([
            new Collection(['code' => 'CS101', 'name' => 'Algorithms II']),
            new Collection(['code' => 'CS999', 'name' => 'New Subject', 'sks' => 2]),
        ]);

        (new SubjectImport($program->id))->collection($rows);

        // Nothing unrelated deleted.
        $this->assertSame(1, Teacher::where('program_id', $program->id)->count(), 'teachers lost');
        $this->assertSame(2, Student::where('program_id', $program->id)->count(), 'students lost');
        $this->assertSame(1, ActivityPlanning::where('program_id', $program->id)->count(), 'plannings lost');
        $this->assertSame(1, Activity::where('program_id', $program->id)->count(), 'activities lost');

        // Existing subject still present (updated), new one created.
        $this->assertSame(2, Subject::where('program_id', $program->id)->count());
        $this->assertSame('Algorithms II', $existing->fresh()->name);
        $this->assertNotNull($activity->fresh());
    }
}
