<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ActivityBatchFilterTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.activities.activity-edit-sheet';

    private function ids(array $options): array
    {
        return array_column($options, 'id');
    }

    public function test_batch_filter_scopes_the_student_group_options(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'PTE', 'name' => 'PTE Program']);

        $batchA = Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => 'PTE-2023', 'number_of_student' => 0]);
        $batchB = Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => 'PTE-2024', 'number_of_student' => 0]);

        $groupA = Student::create(['program_id' => $program->id, 'parent_id' => $batchA->id, 'name' => 'TK-7', 'number_of_student' => 30]);
        $subA   = Student::create(['program_id' => $program->id, 'parent_id' => $groupA->id, 'name' => 'TK-7a', 'number_of_student' => 15]);
        $groupB = Student::create(['program_id' => $program->id, 'parent_id' => $batchB->id, 'name' => 'TK-5', 'number_of_student' => 28]);

        $sheet = Livewire::actingAs($user)->test(self::SHEET, ['programId' => $program->id])->call('openCreate');

        // Batch picker lists only root nodes.
        $this->assertEqualsCanonicalizing([$batchA->id, $batchB->id], $this->ids($sheet->get('batchOptions')));

        // No filter: every node is offered — root batches (selectable as a whole-year
        // set) plus all groups and sub-groups.
        $all = $this->ids($sheet->get('studentOptions'));
        $this->assertEqualsCanonicalizing(
            [$batchA->id, $batchB->id, $groupA->id, $subA->id, $groupB->id],
            $all,
        );

        // Filter to batch A: the batch root itself + its descendants remain.
        $sheet->set('batchFilter', $batchA->id);
        $filtered = $this->ids($sheet->get('studentOptions'));
        $this->assertEqualsCanonicalizing([$batchA->id, $groupA->id, $subA->id], $filtered);
        $this->assertNotContains($groupB->id, $filtered);
        $this->assertNotContains($batchB->id, $filtered);
    }
}
