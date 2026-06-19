<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Activity;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Space;
use App\Models\FetNet\Subject;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ActivityDetailSpacesPaginationTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::client.data.activities.activity-detail-sheet';

    public function test_spaces_are_paginated_five_per_page_with_plotted_count(): void
    {
        $user     = User::factory()->create();
        $client   = Client::create(['user_id' => $user->id]);
        $program  = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $building = Building::create(['client_id' => $client->id, 'name' => 'Gedung A', 'code' => 'A']);
        $subject  = Subject::create(['program_id' => $program->id, 'code' => 'TE101', 'name' => 'Subject', 'credit' => 3]);
        $ay       = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem      = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 3, 'active' => true]);

        // 6 assigned rooms -> 2 pages of 5.
        for ($i = 1; $i <= 6; $i++) {
            $space = Space::create(['client_id' => $client->id, 'building_id' => $building->id, 'name' => "Room {$i}", 'capacity' => 30]);
            $activity->spaces()->attach($space->id, ['assigned_by' => 'client']);
        }

        $sheet = Livewire::actingAs($user)->test(self::SHEET)->call('open', $activity->id);

        // Plotted-room count is shown.
        $sheet->assertSee('6');

        // Page 1: first 5 rooms, not the 6th.
        $sheet->assertSee('Room 1')->assertSee('Room 5')->assertDontSee('Room 6');

        // Page 2: the 6th room appears.
        $sheet->call('spaceNext', 2)->assertSee('Room 6');
    }
}
