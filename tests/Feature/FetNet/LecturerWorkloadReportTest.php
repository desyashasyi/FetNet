<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Services\FetNet\LecturerWorkloadReport;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LecturerWorkloadReportTest extends TestCase
{
    use RefreshDatabase;

    private function makeClient(): Client
    {
        return Client::create(['user_id' => User::factory()->create()->id]);
    }

    private function makeProgram(Client $client, string $abbrev): Program
    {
        return Program::create([
            'client_id' => $client->id,
            'abbrev'    => $abbrev,
            'name'      => $abbrev . ' Program',
        ]);
    }

    private function makeSemester(Client $client, int $yearStart, int $sem): Semester
    {
        $ay = AcademicYear::firstOrCreate(
            ['client_id' => $client->id, 'year_start' => $yearStart],
            ['is_active' => true],
        );

        return Semester::create([
            'client_id'        => $client->id,
            'academic_year_id' => $ay->id,
            'semester'         => $sem,
            'name'             => $sem === 1 ? 'Odd' : 'Even',
        ]);
    }

    private function makeSubject(Program $program, string $code, int $credit): Subject
    {
        return Subject::create([
            'program_id' => $program->id,
            'code'       => $code,
            'name'       => $code . ' Subject',
            'credit'     => $credit,
        ]);
    }

    /** Create a planned activity in $program for $semester teaching $subject, taught by $teachers. */
    private function makeActivity(Program $program, Subject $subject, Semester $semester, array $teachers): Activity
    {
        $planning = ActivityPlanning::firstOrCreate([
            'subject_id'  => $subject->id,
            'program_id'  => $program->id,
            'semester_id' => $semester->id,
        ]);

        $activity = Activity::create([
            'program_id'  => $program->id,
            'planning_id' => $planning->id,
            'duration'    => 2,
            'active'      => true,
        ]);

        $activity->teachers()->attach(collect($teachers)->pluck('id')->all());

        return $activity;
    }

    public function test_recaps_single_program_load_for_active_semester(): void
    {
        $client   = $this->makeClient();
        $program  = $this->makeProgram($client, 'CS');
        $semester = $this->makeSemester($client, 2024, 1);
        $teacher  = Teacher::create(['program_id' => $program->id, 'name' => 'Alice', 'code' => 'ALC']);
        $subject  = $this->makeSubject($program, 'CS101', 3);

        $this->makeActivity($program, $subject, $semester, [$teacher]);

        $report = app(LecturerWorkloadReport::class)->forClient($client, $semester->id);

        $this->assertCount(1, $report['programs']);
        $this->assertSame($program->id, $report['programs'][0]['id']);
        $this->assertSame('CS', $report['programs'][0]['abbrev']);

        $this->assertCount(1, $report['rows']);
        $row = $report['rows'][0];
        $this->assertSame('Alice', $row['name']);
        $this->assertSame(3, $row['perProgram'][$program->id]);
        $this->assertSame(3, $row['total']);
    }

    public function test_empty_when_no_active_semester(): void
    {
        $client = $this->makeClient();
        $report = app(LecturerWorkloadReport::class)->forClient($client, null);

        $this->assertSame([], $report['programs']);
        $this->assertSame([], $report['rows']);
    }

    public function test_counts_cross_client_program_per_activity(): void
    {
        // Home client + program for the lecturer.
        $clientA  = $this->makeClient();
        $progA    = $this->makeProgram($clientA, 'CS');
        $semA     = $this->makeSemester($clientA, 2024, 1); // odd, 2024
        $teacher  = Teacher::create(['program_id' => $progA->id, 'name' => 'Bob', 'code' => 'BOB']);

        // Another client/faculty with its own program + its own matching semester (same year_start + parity).
        $clientB  = $this->makeClient();
        $progB    = $this->makeProgram($clientB, 'EE');
        $semB     = $this->makeSemester($clientB, 2024, 1); // odd, 2024 -> matches period

        // Home prodi: one subject (3 SKS) split into TWO activities -> counted per activity = 6.
        $subA = $this->makeSubject($progA, 'CS101', 3);
        $this->makeActivity($progA, $subA, $semA, [$teacher]);
        $this->makeActivity($progA, $subA, $semA, [$teacher]); // split/second activity, same subject

        // Cross-client prodi: subject 2 SKS, one activity -> 2.
        $subB = $this->makeSubject($progB, 'EE201', 2);
        $this->makeActivity($progB, $subB, $semB, [$teacher]);

        $report = app(LecturerWorkloadReport::class)->forClient($clientA, $semA->id);

        $abbrevs = array_column($report['programs'], 'abbrev');
        $this->assertContains('CS', $abbrevs);
        $this->assertContains('EE', $abbrevs);

        $row = collect($report['rows'])->firstWhere('name', 'Bob');
        $this->assertSame(6, $row['perProgram'][$progA->id]); // per activity: 3 + 3
        $this->assertSame(2, $row['perProgram'][$progB->id]); // cross-client, matched period
        $this->assertSame(8, $row['total']);
    }

    public function test_team_teaching_gives_full_credit_to_each_lecturer(): void
    {
        $client  = $this->makeClient();
        $prog    = $this->makeProgram($client, 'CS');
        $sem     = $this->makeSemester($client, 2024, 1);
        $t1      = Teacher::create(['program_id' => $prog->id, 'name' => 'Carol', 'code' => 'CAR']);
        $t2      = Teacher::create(['program_id' => $prog->id, 'name' => 'Dave', 'code' => 'DAV']);
        $subject = $this->makeSubject($prog, 'CS101', 4);

        $this->makeActivity($prog, $subject, $sem, [$t1, $t2]); // both teach the same activity

        $report = app(LecturerWorkloadReport::class)->forClient($client, $sem->id);

        $carol = collect($report['rows'])->firstWhere('name', 'Carol');
        $dave  = collect($report['rows'])->firstWhere('name', 'Dave');
        $this->assertSame(4, $carol['total']);
        $this->assertSame(4, $dave['total']);
    }

    public function test_excludes_other_periods_and_soft_deleted_activities(): void
    {
        $client   = $this->makeClient();
        $prog     = $this->makeProgram($client, 'CS');
        $semOdd   = $this->makeSemester($client, 2024, 1); // active
        $semEven  = $this->makeSemester($client, 2024, 2); // different parity -> excluded
        $teacher  = Teacher::create(['program_id' => $prog->id, 'name' => 'Erin', 'code' => 'ERN']);

        $counted  = $this->makeSubject($prog, 'CS101', 3);
        $this->makeActivity($prog, $counted, $semOdd, [$teacher]);

        $otherPeriod = $this->makeSubject($prog, 'CS201', 5);
        $this->makeActivity($prog, $otherPeriod, $semEven, [$teacher]); // wrong period

        $deletedSub = $this->makeSubject($prog, 'CS301', 5);
        $deleted    = $this->makeActivity($prog, $deletedSub, $semOdd, [$teacher]);
        $deleted->delete(); // soft-deleted -> excluded

        $report = app(LecturerWorkloadReport::class)->forClient($client, $semOdd->id);

        $row = collect($report['rows'])->firstWhere('name', 'Erin');
        $this->assertSame(3, $row['total']); // only the CS101 odd-period, non-deleted activity
    }

    public function test_for_program_rows_are_program_teachers_with_cross_prodi_columns(): void
    {
        $client   = $this->makeClient();
        $progA    = $this->makeProgram($client, 'CS');
        $semA     = $this->makeSemester($client, 2024, 1);
        $teacher  = Teacher::create(['program_id' => $progA->id, 'name' => 'Bob', 'code' => 'BOB']);

        // Same client, another program with a matching-period semester.
        $progB    = $this->makeProgram($client, 'EE');
        $semB     = $this->makeSemester($client, 2024, 1);

        // Teacher of progA teaches in progA (3 SKS) and in progB (2 SKS).
        $subA = $this->makeSubject($progA, 'CS101', 3);
        $this->makeActivity($progA, $subA, $semA, [$teacher]);
        $subB = $this->makeSubject($progB, 'EE201', 2);
        $this->makeActivity($progB, $subB, $semB, [$teacher]);

        // A teacher NOT in progA must not appear as a row.
        $other = Teacher::create(['program_id' => $progB->id, 'name' => 'Zed', 'code' => 'ZED']);
        $subZ  = $this->makeSubject($progB, 'EE301', 4);
        $this->makeActivity($progB, $subZ, $semB, [$other]);

        $report = app(LecturerWorkloadReport::class)->forProgram($progA, $semA->id);

        // Rows = progA teachers only.
        $names = array_column($report['rows'], 'name');
        $this->assertContains('Bob', $names);
        $this->assertNotContains('Zed', $names);

        $abbrevs = array_column($report['programs'], 'abbrev');
        $this->assertContains('CS', $abbrevs);
        $this->assertContains('EE', $abbrevs); // cross-prodi column

        $bob = collect($report['rows'])->firstWhere('name', 'Bob');
        $this->assertSame(3, $bob['perProgram'][$progA->id]);
        $this->assertSame(2, $bob['perProgram'][$progB->id]);
        $this->assertSame(5, $bob['total']);
    }

    public function test_for_program_includes_guest_teachers_from_other_programs(): void
    {
        $client  = $this->makeClient();
        $progA   = $this->makeProgram($client, 'CS');
        $semA    = $this->makeSemester($client, 2024, 1);

        // Guest lecturer whose HOME program is progB but who teaches in progA.
        $progB   = $this->makeProgram($client, 'EE');
        $guest   = Teacher::create(['program_id' => $progB->id, 'name' => 'Guest', 'code' => 'GST']);

        $subA = $this->makeSubject($progA, 'CS101', 3);
        $this->makeActivity($progA, $subA, $semA, [$guest]);

        $report = app(LecturerWorkloadReport::class)->forProgram($progA, $semA->id);

        $names = array_column($report['rows'], 'name');
        $this->assertContains('Guest', $names); // teaches in progA despite home = progB

        $row = collect($report['rows'])->firstWhere('name', 'Guest');
        $this->assertSame(3, $row['perProgram'][$progA->id]);
        $this->assertSame(3, $row['total']);
    }
}
