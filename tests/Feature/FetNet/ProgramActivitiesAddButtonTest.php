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

class ProgramActivitiesAddButtonTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.activities.idx';

    /** @return array{0:User,1:Semester,2:Subject} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'One', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 2, 'active' => true]);

        return [$user, $sem, $subject];
    }

    public function test_by_subject_view_shows_per_subject_add_button(): void
    {
        [$user, $sem, $subject] = $this->scaffold();

        $html = Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)
            ->set('view', 'subject')
            ->html();

        $this->assertStringContainsString('open-activity-create', $html);
        $this->assertStringContainsString('subjectId: ' . $subject->id, $html);
    }

    public function test_all_view_has_no_add_button(): void
    {
        [$user, $sem] = $this->scaffold();

        $html = Livewire::actingAs($user)->test(self::PAGE)
            ->set('semesterId', $sem->id)
            ->set('view', 'all')
            ->html();

        // The per-subject add button (its subjectId dispatch payload) is absent in All view.
        // (The string "open-activity-create" still appears as the sheet's registered listener.)
        $this->assertStringNotContainsString('subjectId:', $html);
    }
}
