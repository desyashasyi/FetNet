<?php

namespace Tests\Feature\FetNet;

use App\Events\FetNet\CompileFetRequestedEvent;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Semester;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Event;
use Livewire\Livewire;
use Tests\TestCase;

class CompileProgressBarTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::client.timetable.idx';

    /** @return array{0:User,1:Semester} */
    private function scaffold(): array
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        return [$user, $sem];
    }

    public function test_clicking_compile_shows_the_progress_bar(): void
    {
        Event::fake([CompileFetRequestedEvent::class]);
        [$user, $sem] = $this->scaffold();

        Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id)
            ->assertDontSee('Compiling FET file')
            ->call('compile')
            ->assertSet('compiling', true)
            ->assertSee('Compiling FET file');

        Event::assertDispatched(CompileFetRequestedEvent::class);
    }

    public function test_compiled_broadcast_resolves_the_progress_bar(): void
    {
        [$user, $sem] = $this->scaffold();

        Livewire::actingAs($user)->test(self::PAGE)->set('semesterId', $sem->id)
            ->set('compiling', true)
            ->assertSee('Compiling FET file')
            ->call('onCompiled', ['status' => 'success'])
            ->assertSet('compiling', false)
            ->assertDontSee('Compiling FET file');
    }
}
