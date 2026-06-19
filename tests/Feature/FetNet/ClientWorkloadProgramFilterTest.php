<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ClientWorkloadProgramFilterTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.data.workload.idx';

    public function test_program_selector_scopes_the_recap_to_that_program(): void
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        $progA = Program::create(['client_id' => $client->id, 'abbrev' => 'AA', 'name' => 'A Program']);
        $progB = Program::create(['client_id' => $client->id, 'abbrev' => 'BB', 'name' => 'B Program']);

        $teachA = Teacher::create(['program_id' => $progA->id, 'name' => 'Alice', 'code' => 'AL']);
        $teachB = Teacher::create(['program_id' => $progB->id, 'name' => 'Bob',   'code' => 'BO']);

        $this->teachIn($progA, $sem, 'AA101', $teachA);
        $this->teachIn($progB, $sem, 'BB101', $teachB);

        // No filter: both lecturers appear.
        $all = Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id);
        $names = collect($all->viewData('rows'))->pluck('name');
        $this->assertTrue($names->contains('Alice'));
        $this->assertTrue($names->contains('Bob'));

        // Filtered to program A: only A's lecturer remains.
        $filtered = $all->set('programId', $progA->id);
        $namesA = collect($filtered->viewData('rows'))->pluck('name');
        $this->assertTrue($namesA->contains('Alice'));
        $this->assertFalse($namesA->contains('Bob'));
    }

    private function teachIn(Program $program, Semester $sem, string $code, Teacher $teacher): void
    {
        $subject  = Subject::create(['program_id' => $program->id, 'code' => $code, 'name' => "{$code} Subject", 'credit' => 3]);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 2, 'active' => true]);
        $activity->teachers()->attach($teacher->id);
    }
}
