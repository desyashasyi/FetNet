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

class ActivitySubjectSemesterFilterTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.activities.idx';

    /** @return array{0:User,1:Semester,2:Activity,3:Activity} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'PTE', 'name' => 'PTE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2026, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        $act1 = $this->activity($program, $sem, 'EL101', courseSemester: 1);
        $act3 = $this->activity($program, $sem, 'EL301', courseSemester: 3);

        return [$user, $sem, $act1, $act3];
    }

    private function activity(Program $program, Semester $sem, string $code, int $courseSemester): Activity
    {
        $subject  = Subject::create(['program_id' => $program->id, 'code' => $code, 'name' => "{$code} Subject", 'credit' => 3, 'semester' => $courseSemester]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);

        return Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);
    }

    public function test_course_semester_options_are_the_distinct_subject_semesters(): void
    {
        [$user, $sem] = $this->scaffold();

        $opts = Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id)
            ->viewData('subjectSemesterOptions');

        $this->assertSame([1, 3], array_column($opts, 'id'));
    }

    public function test_filter_limits_the_all_view_to_the_chosen_course_semester(): void
    {
        [$user, $sem, $act1, $act3] = $this->scaffold();

        $page = Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)->set('view', 'all');

        $this->assertEqualsCanonicalizing([$act1->id, $act3->id], $page->viewData('activities')->pluck('id')->all());

        $page->set('subjectSemester', 3);
        $this->assertSame([$act3->id], $page->viewData('activities')->pluck('id')->all());
    }

    public function test_filter_limits_the_by_subject_view(): void
    {
        [$user, $sem] = $this->scaffold();

        $page = Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)->set('view', 'subject')
            ->set('subjectSemester', 1);

        $codes = $page->viewData('subjects')->pluck('code')->all();
        $this->assertSame(['EL101'], $codes);
    }
}
