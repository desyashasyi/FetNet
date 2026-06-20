<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class StudentNodeUniqueNameTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.students.student-form-sheet';

    /** @return array{0:User,1:Program} */
    private function scaffold(): array
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        return [$user, $program];
    }

    public function test_batch_name_must_be_unique_within_the_program(): void
    {
        [$user, $program] = $this->scaffold();
        Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => '2021', 'number_of_student' => 10]);

        Livewire::actingAs($user)->test(self::SHEET)
            ->call('openCreateBatch')
            ->set('batchName', '2021')->set('batchCount', 5)
            ->call('saveBatch')
            ->assertHasErrors(['batchName' => 'unique']);

        $this->assertSame(1, Student::where('program_id', $program->id)->whereNull('parent_id')->count());
    }

    public function test_group_name_must_be_unique_among_siblings_but_not_across_parents(): void
    {
        [$user, $program] = $this->scaffold();
        $batchA = Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => '2021', 'number_of_student' => 0]);
        $batchB = Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => '2022', 'number_of_student' => 0]);
        Student::create(['program_id' => $program->id, 'parent_id' => $batchA->id, 'name' => 'A', 'number_of_student' => 30]);

        // Duplicate "A" under the same batch -> rejected.
        Livewire::actingAs($user)->test(self::SHEET)
            ->call('openAddGroup', $batchA->id)
            ->set('groupName', 'A')->set('groupCount', 25)
            ->call('saveGroup')
            ->assertHasErrors(['groupName' => 'unique']);

        // Same "A" under a different batch -> allowed.
        Livewire::actingAs($user)->test(self::SHEET)
            ->call('openAddGroup', $batchB->id)
            ->set('groupName', 'A')->set('groupCount', 25)
            ->call('saveGroup')
            ->assertHasNoErrors();

        $this->assertSame(2, Student::where('name', 'A')->count());
    }

    public function test_editing_a_node_keeping_its_own_name_is_allowed(): void
    {
        [$user, $program] = $this->scaffold();
        $batch = Student::create(['program_id' => $program->id, 'parent_id' => null, 'name' => '2021', 'number_of_student' => 10]);

        Livewire::actingAs($user)->test(self::SHEET)
            ->call('openEditBatch', $batch->id)
            ->set('batchCount', 99)
            ->call('saveBatch')
            ->assertHasNoErrors();

        $this->assertSame(99, $batch->fresh()->number_of_student);
    }
}
