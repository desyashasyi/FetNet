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
        $ay = AcademicYear::create([
            'client_id'  => $client->id,
            'year_start' => $yearStart,
            'is_active'  => true,
        ]);

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
}
