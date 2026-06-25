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

class TimetableTeacherTableDurationTest extends TestCase
{
    use RefreshDatabase;

    public function test_table_mode_spans_the_full_sks_time_range(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'EL1', 'name' => 'One', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 3, 'active' => true]);
        $act->teachers()->attach(Teacher::create(['program_id' => $program->id, 'code' => 'DDW', 'name' => 'Didin'])->id);

        FetCompile::create([
            'client_id' => $client->id, 'semester_id' => $sem->id,
            'status' => 'success', 'solver_status' => 'success', 'published_at' => now(),
        ]);
        // A 3-hour class starting at the first hour: default hour labels are 1h blocks from
        // 07:00, so the range must span 07:00–10:00 (not just the single starting slot).
        TimetableSlot::create([
            'client_id' => $client->id, 'semester_id' => $sem->id, 'activity_id' => $act->id,
            'day_index' => 1, 'hour_index' => 1, 'duration' => 3, 'locked' => false,
        ]);

        $html = Livewire::actingAs($user)->test('pages::program.timetable.teachers.idx')
            ->set('semesterId', $sem->id)
            ->set('view', 'teacher')
            ->set('mode', 'table')
            ->html();

        $this->assertStringContainsString('07:00–10:00', $html);
    }
}
