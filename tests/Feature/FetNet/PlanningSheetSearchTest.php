<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class PlanningSheetSearchTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.activities.planning-sheet';

    public function test_search_filters_subjects_by_name_or_code(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);
        $ay      = AcademicYear::firstOrCreate(['client_id' => $client->id, 'year_start' => 2024], ['is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'Algorithms', 'credit' => 3, 'semester' => 1]);
        Subject::create(['program_id' => $program->id, 'code' => 'CS202', 'name' => 'Databases', 'credit' => 3, 'semester' => 1]);

        $component = Livewire::actingAs($user)
            ->test(self::SHEET, ['programId' => $program->id, 'semesterId' => $sem->id])
            ->call('open');

        // No filter -> both subjects.
        $this->assertCount(2, $component->get('planSubjects'));

        // Match by name.
        $codes = array_column($component->set('planSearch', 'Algo')->get('planSubjects'), 'code');
        $this->assertSame(['CS101'], $codes);

        // Match by code.
        $codes = array_column($component->set('planSearch', 'CS202')->get('planSubjects'), 'code');
        $this->assertSame(['CS202'], $codes);

        // Reset on reopen.
        $component->call('open');
        $this->assertSame('', $component->get('planSearch'));
        $this->assertCount(2, $component->get('planSubjects'));
    }

    public function test_toggle_keeps_modal_open_and_defers_parent_refresh(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);
        $ay      = AcademicYear::firstOrCreate(['client_id' => $client->id, 'year_start' => 2024], ['is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'Algorithms', 'credit' => 3, 'semester' => 1]);

        $component = Livewire::actingAs($user)
            ->test(self::SHEET, ['programId' => $program->id, 'semesterId' => $sem->id])
            ->call('open')
            ->call('togglePlanning', $subject->id);

        // Modal stays open; parent NOT yet notified (avoids morph closing the modal).
        $component->assertSet('modal', true)
            ->assertSet('planDirty', true)
            ->assertNotDispatched('planning-changed');

        // Done closes and notifies the parent once.
        $component->call('closePlanning')
            ->assertSet('modal', false)
            ->assertSet('planDirty', false)
            ->assertDispatched('planning-changed');
    }
}
