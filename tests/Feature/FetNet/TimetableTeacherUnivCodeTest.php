<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Models\FetNet\TimetableSlot;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class TimetableTeacherUnivCodeTest extends TestCase
{
    use RefreshDatabase;

    public function test_table_mode_shows_lecturer_with_univ_code(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'One', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 2, 'active' => true]);
        $act->teachers()->attach(Teacher::create([
            'program_id' => $program->id, 'code' => 'DDW', 'univ_code' => '2934', 'name' => 'Didin',
        ])->id);

        // A published timetable is required for the read-only view to show slots.
        FetCompile::create([
            'client_id' => $client->id, 'semester_id' => $sem->id,
            'status' => 'success', 'solver_status' => 'success', 'published_at' => now(),
        ]);
        TimetableSlot::create([
            'client_id' => $client->id, 'semester_id' => $sem->id, 'activity_id' => $act->id,
            'day_index' => 1, 'hour_index' => 1, 'duration' => 2, 'locked' => false,
        ]);

        $html = Livewire::actingAs($user)->test('pages::program.timetable.teachers.idx')
            ->set('semesterId', $sem->id)
            ->set('view', 'teacher')
            ->set('mode', 'table')
            ->html();

        $this->assertStringContainsString('DDW (2934)', $html);
    }
}
