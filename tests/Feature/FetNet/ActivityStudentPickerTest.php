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
        $this->assertContains('2026', $labels);                // batch (root) is selectable as a student set
        $this->assertContains($group->id, $ids);
        $this->assertContains($sub->id, $ids);
        $this->assertContains($batch->id, $ids);
    }

    public function test_subgroups_appear_even_with_many_groups(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        $batch = Student::create(['program_id' => $program->id, 'name' => '2026']);

        // 20 groups named so they sort before the subgroup below.
        for ($i = 1; $i <= 20; $i++) {
            Student::create(['program_id' => $program->id, 'name' => sprintf('G%02d', $i), 'parent_id' => $batch->id]);
        }

        // A subgroup whose own name sorts AFTER every group — old limit(15) would drop it.
        $lateGroup = Student::create(['program_id' => $program->id, 'name' => 'ZGROUP', 'parent_id' => $batch->id]);
        $sub       = Student::create(['program_id' => $program->id, 'name' => 'ZSUB', 'parent_id' => $lateGroup->id]);

        $options = Livewire::actingAs($user)
            ->test(self::SHEET, ['programId' => $program->id])
            ->call('searchStudents', '')
            ->get('studentOptions');

        $ids = array_column($options, 'id');
        $this->assertContains($sub->id, $ids); // subgroup not truncated by the limit
        $this->assertContains('2026 / ZGROUP / ZSUB', array_column($options, 'name'));
    }
}
