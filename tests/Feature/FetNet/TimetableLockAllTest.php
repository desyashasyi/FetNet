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

class TimetableLockAllTest extends TestCase
{
    use RefreshDatabase;

    /** @return array{0:User,1:Client,2:Semester,3:Program,4:Program} */
    private function scaffold(): array
    {
        $user  = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay    = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem   = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $progA = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'AA', 'name' => 'A']);
        $progB = Program::create(['client_id' => $client->id, 'abbrev' => 'BB', 'name' => 'B']);

        return [$user, $client, $sem, $progA, $progB];
    }

    private function slotFor(Client $client, Semester $sem, Program $program, int $day): TimetableSlot
    {
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'C' . $program->id . $day, 'name' => 'S', 'credit' => 2]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 1, 'active' => true]);

        return TimetableSlot::create([
            'client_id' => $client->id, 'semester_id' => $sem->id, 'activity_id' => $act->id,
            'day_index' => $day, 'hour_index' => 1, 'duration' => 1, 'locked' => false,
        ]);
    }

    public function test_lock_all_locks_every_slot_in_the_semester(): void
    {
        [$user, $client, $sem, $progA, $progB] = $this->scaffold();
        $a = $this->slotFor($client, $sem, $progA, 1);
        $b = $this->slotFor($client, $sem, $progB, 2);

        Livewire::actingAs($user)->test('pages::client.timetable.view.idx', ['sem' => $sem->id])
            ->call('lockAll', true);

        $this->assertTrue($a->fresh()->locked);
        $this->assertTrue($b->fresh()->locked);
    }

    public function test_lock_all_scopes_to_the_selected_program(): void
    {
        [$user, $client, $sem, $progA, $progB] = $this->scaffold();
        $a = $this->slotFor($client, $sem, $progA, 1);
        $b = $this->slotFor($client, $sem, $progB, 2);

        Livewire::actingAs($user)->test('pages::client.timetable.view.idx', ['sem' => $sem->id])
            ->set('programFilterId', $progA->id)
            ->call('lockAll', true);

        $this->assertTrue($a->fresh()->locked);   // program A locked
        $this->assertFalse($b->fresh()->locked);  // program B untouched
    }

    public function test_unlock_all_clears_locks(): void
    {
        [$user, $client, $sem, $progA] = $this->scaffold();
        $a = $this->slotFor($client, $sem, $progA, 1);
        $a->update(['locked' => true]);

        Livewire::actingAs($user)->test('pages::client.timetable.view.idx', ['sem' => $sem->id])
            ->call('lockAll', false);

        $this->assertFalse($a->fresh()->locked);
    }
}
