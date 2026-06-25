<?php

namespace Tests\Feature\FetNet;

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
use Livewire\Livewire;
use Tests\TestCase;

class WorkloadTablePopoverTest extends TestCase
{
    use RefreshDatabase;

    private const TABLE = 'pages::client.data.workload.workload-table';

    /** @return array{0:User,1:Client,2:Program,3:Semester} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        return [$user, $client, $program, $sem];
    }

    public function test_child_builds_recap_and_renders_lecturer_and_subject_in_popover(): void
    {
        [$user, $client, $program, $sem] = $this->scaffold();

        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL9', 'name' => 'SISTEM KENDALI', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 3, 'active' => true]);
        $act->teachers()->attach(Teacher::create(['program_id' => $program->id, 'code' => 'YKN', 'name' => 'Abdu Yakan'])->id);

        // The child fetches its own data from the scalar ids it receives (regression: passing
        // the nested report array as a prop dropped it, leaving the popover empty).
        $html = Livewire::actingAs($user)->test(self::TABLE, [
            'clientId' => $client->id, 'semesterId' => $sem->id,
        ])->html();

        $this->assertStringContainsString('Abdu Yakan', $html);   // lecturer row
        $this->assertStringContainsString('SISTEM KENDALI', $html); // subject in the hover popover
        $this->assertStringContainsString('dropdown-content', $html); // the popover itself
    }

    public function test_popover_shows_tandem_partner_for_team_teaching(): void
    {
        [$user, $client, $program, $sem] = $this->scaffold();

        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL9', 'name' => 'KENDALI', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 3, 'active' => true]);

        // Two lecturers on one activity = team teaching: P1 then P2.
        $t1 = Teacher::create(['program_id' => $program->id, 'code' => 'AAA', 'name' => 'Lecturer One']);
        $t2 = Teacher::create(['program_id' => $program->id, 'code' => 'BBB', 'name' => 'Lecturer Two']);
        $act->teachers()->attach($t1->id);
        $act->teachers()->attach($t2->id);

        $html = Livewire::actingAs($user)->test(self::TABLE, [
            'clientId' => $client->id, 'semesterId' => $sem->id,
        ])->html();

        // Each lecturer's popover names the partner.
        $this->assertStringContainsString('tandem:', $html);
        $this->assertStringContainsString('AAA', $html);
        $this->assertStringContainsString('BBB', $html);
    }
}
