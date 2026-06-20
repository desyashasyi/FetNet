<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Livewire\Livewire;
use Maatwebsite\Excel\Concerns\FromArray;
use Maatwebsite\Excel\Facades\Excel;
use Tests\TestCase;

class SubjectImportSheetTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.subjects.import-sheet';

    private function xlsxUpload(): UploadedFile
    {
        $export = new class implements FromArray {
            public function array(): array
            {
                return [
                    ['code', 'name', 'credit', 'semester'],
                    ['TX101', 'Test Subject', 3, 1],
                ];
            }
        };

        $bytes = Excel::raw($export, \Maatwebsite\Excel\Excel::XLSX);

        return UploadedFile::fake()->createWithContent('subjects.xlsx', $bytes);
    }

    public function test_synchronous_import_alerts_success_and_refreshes(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        Livewire::actingAs($user)->test(self::SHEET)
            ->set('importFile', $this->xlsxUpload())
            ->call('import')
            ->assertHasNoErrors()
            ->assertSet('modal', false)
            ->assertDispatched('subject-changed')
            ->assertDispatched('refresh-subject-options');

        // Imported inline in the same request — no queue/broadcast needed.
        $this->assertDatabaseHas('fetnet_subject', ['code' => 'TX101', 'program_id' => $program->id]);
    }
}
