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

class ActivitiesSortingTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Build three activities whose subjects sort, by (semester, code), as:
     * (1, AAA) < (1, ZZZ) < (2, AAA). Returns the activity ids in that expected order.
     *
     * @return array{0:User,1:Program,2:Semester,3:array<int>}
     */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        // Insert in a deliberately wrong order so id-order != semester/code-order.
        $sem2A = $this->activityFor($program, $sem, semester: 2, code: 'AAA');
        $sem1Z = $this->activityFor($program, $sem, semester: 1, code: 'ZZZ');
        $sem1A = $this->activityFor($program, $sem, semester: 1, code: 'AAA');

        return [$user, $program, $sem, [$sem1A, $sem1Z, $sem2A]];
    }

    private function activityFor(Program $program, Semester $sem, int $semester, string $code): int
    {
        $subject  = Subject::create(['program_id' => $program->id, 'code' => $code, 'name' => "Subj {$code}", 'credit' => 3, 'semester' => $semester]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);

        return Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true])->id;
    }

    public function test_client_all_view_sorts_by_semester_then_subject_code(): void
    {
        [$user, , $sem, $expected] = $this->scaffold();

        $component = Livewire::actingAs($user)->test('pages::client.data.activities.idx')
            ->set('view', 'all')->set('semesterId', $sem->id);

        $this->assertSame($expected, $component->viewData('activities')->pluck('id')->all());
    }

    public function test_program_all_view_sorts_by_semester_then_subject_code(): void
    {
        [$user, , $sem, $expected] = $this->scaffold();

        $component = Livewire::actingAs($user)->test('pages::program.data.activities.idx')
            ->set('view', 'all')->set('semesterId', $sem->id);

        $this->assertSame($expected, $component->viewData('activities')->pluck('id')->all());
    }
}
