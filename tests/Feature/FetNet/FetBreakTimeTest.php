<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\Semester;
use App\Models\User;
use App\Services\FetNet\FetSolutionParser;
use App\Services\FetNet\FetXmlBuilder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class FetBreakTimeTest extends TestCase
{
    use RefreshDatabase;

    private function configFor(Client $client): void
    {
        ClientConfig::create([
            'client_id'       => $client->id,
            'start_time'      => '07:00',
            'slot_duration'   => 50,
            'number_of_hours' => 8,
            'number_of_days'  => 5,
            'no_break'        => false,
            'break_start'     => '12:00',
            'break_end'       => '13:00',
        ]);
    }

    public function test_builder_includes_break_hour_and_break_constraint(): void
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $this->configFor($client);
        $ay  = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);

        $xml = app(FetXmlBuilder::class)->build($client, $sem);

        // The break hour is a real hour in the list (so the day's halves aren't consecutive).
        $this->assertStringContainsString('<Name>12:00</Name>', $xml);
        // The bookable hour after lunch is present too.
        $this->assertStringContainsString('<Name>13:00</Name>', $xml);
        // And the break is marked unavailable for everyone.
        $this->assertStringContainsString('<ConstraintBreakTimes>', $xml);
        $this->assertStringContainsString('<Hour>12:00</Hour>', $xml);
    }

    public function test_parser_maps_post_break_hour_to_bookable_index_not_fet_position(): void
    {
        Storage::fake('local');

        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $this->configFor($client);

        $dir    = 'fet-solve/1/timetables/sem1';
        $source = "{$dir}/sem1_data_and_timetable.fet";
        $sol    = "{$dir}/sem1_activities.xml";
        $mapRel = 'fet/1/sem1.map.json';

        // Source lists hours INCLUDING the break (12:00 at FET position 7); "13:00" is FET
        // position 8 but the app's bookable index 7.
        $hours = ['07:00', '07:50', '08:40', '09:30', '10:20', '11:10', '12:00', '13:00', '13:50'];
        $hoursXml = implode('', array_map(fn ($h) => "<Hour><Name>{$h}</Name></Hour>", $hours));
        $daysXml  = implode('', array_map(fn ($d) => "<Day><Name>{$d}</Name></Day>",
            ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']));

        Storage::disk('local')->put($source,
            "<fet><Days_List>{$daysXml}</Days_List><Hours_List>{$hoursXml}</Hours_List>"
            . "<Activities_List><Activity><Id>1</Id><Duration>2</Duration></Activity></Activities_List></fet>");
        Storage::disk('local')->put($sol,
            '<Timetable><Activity><Id>1</Id><Day>Monday</Day><Hour>13:00</Hour><Room></Room></Activity></Timetable>');
        Storage::disk('local')->put($mapRel, json_encode(['5' => [1]]));

        $rows = (new FetSolutionParser())->parse($source, $mapRel, $client->id);

        $this->assertCount(1, $rows);
        $this->assertSame(5, $rows[0]['activity_id']);
        $this->assertSame(1, $rows[0]['day_index']);
        // 13:00 is the 7th BOOKABLE hour (break excluded), not the 8th FET position.
        $this->assertSame(7, $rows[0]['hour_index']);
    }
}
