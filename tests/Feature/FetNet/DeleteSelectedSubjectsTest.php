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

class DeleteSelectedSubjectsTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.subjects.⚡idx';

    public function test_delete_selected_removes_only_chosen_subjects_and_their_activities(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);

        $ay  = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        $s1 = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'A', 'credit' => 3]);
        $s2 = Subject::create(['program_id' => $program->id, 'code' => 'CS102', 'name' => 'B', 'credit' => 3]);
        $s3 = Subject::create(['program_id' => $program->id, 'code' => 'CS103', 'name' => 'C', 'credit' => 3]);

        // s1 has a planned activity to verify cascade.
        $planning = ActivityPlanning::create(['subject_id' => $s1->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 2, 'active' => true]);

        Livewire::actingAs($user)
            ->test(self::PAGE)
            ->set('selected', [$s1->id, $s2->id])
            ->call('confirmDeleteSelected')
            ->assertSet('delSelModal', true)
            ->call('deleteSelected')
            ->assertSet('delSelModal', false)
            ->assertSet('selected', []);

        $this->assertSame(0, Subject::whereIn('id', [$s1->id, $s2->id])->count()); // selected gone
        $this->assertSame(1, Subject::where('id', $s3->id)->count());              // unselected kept
        $this->assertSame(0, Activity::where('program_id', $program->id)->count()); // cascaded
    }

    public function test_delete_selected_noop_when_nothing_selected(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);
        $s1      = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'A', 'credit' => 3]);

        Livewire::actingAs($user)
            ->test(self::PAGE)
            ->call('confirmDeleteSelected')
            ->assertSet('delSelModal', false); // no modal without a selection

        $this->assertSame(1, Subject::where('id', $s1->id)->count());
    }
}
