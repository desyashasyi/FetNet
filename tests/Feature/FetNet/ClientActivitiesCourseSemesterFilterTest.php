<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ClientActivitiesCourseSemesterFilterTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.data.activities.idx';

    public function test_course_semester_filter_scopes_the_all_view(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2026, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        $act1 = $this->activity($program, $sem, 'EL101', 1);
        $act5 = $this->activity($program, $sem, 'EL501', 5);

        $page = Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)->set('view', 'all');

        // Options are the distinct subject semesters.
        $this->assertSame([1, 5], array_column($page->viewData('subjectSemesterOptions'), 'id'));

        // Unfiltered shows both; filtering to 5 shows only the semester-5 activity.
        $this->assertEqualsCanonicalizing([$act1->id, $act5->id], $page->viewData('activities')->pluck('id')->all());

        $page->set('subjectSemester', 5);
        $this->assertSame([$act5->id], $page->viewData('activities')->pluck('id')->all());
    }

    private function activity(Program $program, Semester $sem, string $code, int $courseSemester): Activity
    {
        $subject  = Subject::create(['program_id' => $program->id, 'code' => $code, 'name' => "{$code} Subject", 'credit' => 3, 'semester' => $courseSemester]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);

        return Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);
    }
}
