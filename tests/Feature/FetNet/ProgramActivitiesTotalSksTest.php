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

class ProgramActivitiesTotalSksTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.activities.idx';

    /** @return array{0:User,1:Program,2:Semester} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        // S1 (3 SKS) with two activities, S2 (2 SKS) with one activity.
        $s1 = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'One', 'credit' => 3, 'semester' => 1]);
        $s2 = Subject::create(['program_id' => $program->id, 'code' => 'EL2', 'name' => 'Two', 'credit' => 2, 'semester' => 2]);

        // One planning per (subject, semester); S1 carries two activities (parallel classes).
        $plan1 = ActivityPlanning::create(['subject_id' => $s1->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $plan2 = ActivityPlanning::create(['subject_id' => $s2->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $plan1->id, 'duration' => 2, 'active' => true]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $plan1->id, 'duration' => 2, 'active' => true]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $plan2->id, 'duration' => 2, 'active' => true]);

        return [$user, $program, $sem];
    }

    public function test_all_view_totals_sks_per_activity_across_all_pages(): void
    {
        [$user, , $sem] = $this->scaffold();

        // 2 activities of a 3-SKS subject + 1 activity of a 2-SKS subject = 8.
        Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)
            ->set('view', 'all')
            ->assertViewHas('totalSks', 8);
    }

    public function test_subject_view_totals_sks_per_subject(): void
    {
        [$user, , $sem] = $this->scaffold();

        // 3-SKS subject + 2-SKS subject = 5 (each subject counted once).
        Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)
            ->set('view', 'subject')
            ->assertViewHas('totalSks', 5);
    }
}
