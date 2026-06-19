<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Semester;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class CompileHistoryPaginationTest extends TestCase
{
    use RefreshDatabase;

    private const CARD = 'pages::client.timetable.compile-history-card';

    public function test_compile_history_paginates_ten_per_page(): void
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);

        foreach (range(1, 11) as $i) {
            FetCompile::create([
                'client_id'   => $client->id,
                'semester_id' => $sem->id,
                'user_id'     => $user->id,
                'status'      => 'success',
            ]);
        }

        $card = Livewire::actingAs($user)->test(self::CARD, ['clientId' => $client->id, 'semesterId' => $sem->id]);

        $compiles = $card->instance()->compiles();
        $this->assertSame(11, $compiles->total());
        $this->assertSame(10, $compiles->count());      // first page holds 10
        $this->assertTrue($compiles->hasPages());

        $card->call('nextPage');
        $this->assertSame(1, $card->instance()->compiles()->count()); // second page holds the 11th
    }
}
