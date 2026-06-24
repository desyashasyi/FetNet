<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Semester;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Storage;
use Livewire\Livewire;
use Tests\TestCase;

class ClearFetFilesTest extends TestCase
{
    use RefreshDatabase;

    public function test_clear_fet_deletes_all_files_and_nulls_paths(): void
    {
        Storage::fake('local');

        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $compile = FetCompile::create([
            'client_id'          => $client->id,
            'semester_id'        => $sem->id,
            'status'             => 'success',
            'path'               => "fet/{$client->id}/sem{$sem->id}.fet",
            'solver_result_path' => "fet-solve/1/timetables/sem{$sem->id}/sem{$sem->id}_data_and_timetable.fet",
        ]);

        Storage::disk('local')->put("fet/{$client->id}/sem{$sem->id}.fet", '<fet/>');
        Storage::disk('local')->put("fet/{$client->id}/sem{$sem->id}.map.json", '{}');
        Storage::disk('local')->put($compile->solver_result_path, '<fet/>');

        Livewire::actingAs($user)->test('pages::client.timetable.idx')
            ->set('academicYearId', $ay->id)
            ->set('semesterId', $sem->id)
            ->call('clearFet');

        Storage::disk('local')->assertMissing("fet/{$client->id}/sem{$sem->id}.fet");
        Storage::disk('local')->assertMissing("fet/{$client->id}/sem{$sem->id}.map.json");
        Storage::disk('local')->assertMissing($compile->solver_result_path);

        $fresh = $compile->fresh();
        $this->assertNull($fresh->path);
        $this->assertNull($fresh->solver_result_path);
    }

    public function test_clear_fet_does_not_touch_other_clients(): void
    {
        Storage::fake('local');

        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        $other  = Client::create(['user_id' => User::factory()->create()->id]);
        Storage::disk('local')->put("fet/{$other->id}/sem9.fet", '<fet/>');

        Livewire::actingAs($user)->test('pages::client.timetable.idx')
            ->set('academicYearId', $ay->id)
            ->set('semesterId', $sem->id)
            ->call('clearFet');

        Storage::disk('local')->assertExists("fet/{$other->id}/sem9.fet");
    }
}
