<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ActivityStudentPickerTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.activities.activity-edit-sheet';

    public function test_student_options_show_full_hierarchy_path(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        $batch = Student::create(['program_id' => $program->id, 'name' => '2026']);
        $group = Student::create(['program_id' => $program->id, 'name' => 'TE01-1', 'parent_id' => $batch->id]);
        $sub   = Student::create(['program_id' => $program->id, 'name' => 'A', 'parent_id' => $group->id]);

        $options = Livewire::actingAs($user)
            ->test(self::SHEET, ['programId' => $program->id])
            ->call('searchStudents', '')
            ->get('studentOptions');

        $labels = array_column($options, 'name');
        $ids    = array_column($options, 'id');

        $this->assertContains('2026 / TE01-1', $labels);       // group
        $this->assertContains('2026 / TE01-1 / A', $labels);   // sub-group
        $this->assertNotContains('2026', $labels);             // batch not selectable
        $this->assertContains($group->id, $ids);
        $this->assertContains($sub->id, $ids);
        $this->assertNotContains($batch->id, $ids);
    }
}
