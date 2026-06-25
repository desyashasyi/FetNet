<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\TimetableSlot;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class TimetablePrintHeaderTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.timetable.view.idx';

    /** @return array{0:User,1:Semester,2:Program} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'S', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 1, 'active' => true]);
        TimetableSlot::create([
            'client_id' => $client->id, 'semester_id' => $sem->id, 'activity_id' => $act->id,
            'day_index' => 1, 'hour_index' => 1, 'duration' => 1, 'locked' => false,
        ]);

        return [$user, $sem, $program];
    }

    public function test_print_header_names_the_selected_program(): void
    {
        [$user, $sem, $program] = $this->scaffold();

        $html = Livewire::actingAs($user)->test(self::PAGE, ['sem' => $sem->id])
            ->set('mode', 'table')
            ->set('programFilterId', $program->id)
            ->html();

        // Print-only heading carries the selected program so the printout is labeled.
        $this->assertStringContainsString('Generated Timetable — TE', $html);
        $this->assertStringContainsString('print:block', $html);  // the print heading wrapper
    }

    public function test_print_header_says_all_programs_when_no_filter(): void
    {
        [$user, $sem] = $this->scaffold();

        $html = Livewire::actingAs($user)->test(self::PAGE, ['sem' => $sem->id])
            ->set('mode', 'table')
            ->html();

        $this->assertStringContainsString('Generated Timetable — All Programs', $html);
    }
}
