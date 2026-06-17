<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\ClusterBase;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class TeacherProgramFilterTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.teachers.⚡idx';

    public function test_program_filter_lists_cluster_programs_and_scopes_teachers(): void
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);

        $base = ClusterBase::create(['client_id' => $client->id, 'code' => 'CB', 'name' => 'Base']);

        $progA = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        $progB = Program::create(['client_id' => $client->id, 'user_id' => User::factory()->create()->id, 'abbrev' => 'EE', 'name' => 'EE Program']);

        Cluster::create(['program_id' => $progA->id, 'cluster_base_id' => $base->id]);
        Cluster::create(['program_id' => $progB->id, 'cluster_base_id' => $base->id]);

        Teacher::create(['program_id' => $progA->id, 'name' => 'Alice', 'code' => 'ALC']);
        Teacher::create(['program_id' => $progB->id, 'name' => 'Bob',   'code' => 'BOB']);

        $component = Livewire::actingAs($user)->test(self::PAGE);

        // Selector lists both cluster programs.
        $component->assertSee('TE Program')->assertSee('EE Program');

        // No filter -> whole cluster (both teachers visible).
        $component->assertSee('Alice')->assertSee('Bob');

        // Filter to progB -> only its teachers.
        $component->set('filterProgramId', $progB->id)
            ->assertSee('Bob')
            ->assertDontSee('Alice');
    }

    public function test_no_selector_when_not_in_a_cluster(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);
        Teacher::create(['program_id' => $program->id, 'name' => 'Solo', 'code' => 'SOL']);

        Livewire::actingAs($user)->test(self::PAGE)
            ->assertSee('Solo')
            ->assertDontSee('All Programs'); // selector hidden when not clustered
    }
}
