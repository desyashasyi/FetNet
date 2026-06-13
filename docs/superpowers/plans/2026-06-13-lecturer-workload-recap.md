# Lecturer Workload Recap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `/client/data/workload` page recapping each client-owned lecturer's SKS load per study program (cross-prodi, system-wide) with a per-row total, for the active semester period.

**Architecture:** A pure-ish service `LecturerWorkloadReport` builds the recap matrix from one aggregate query (distinct teacher×prodi×subject credit), tested with a sqlite feature test. A Livewire 4 SFC page (`⚡idx`) provides academic-year/semester filters via the existing `HasProgramSemester` trait and renders a co-located child component (`workload-table`) using a MaryUI `x-table` with dynamic prodi columns.

**Tech Stack:** Laravel 12, Livewire 4 (SFC), MaryUI, PHPUnit 11, sqlite `:memory:` test DB.

---

## Reference Facts (verified against codebase)

- **Tables:** `fetnet_client`, `institution_program` (Program model), `fetnet_academic_year`, `fetnet_semester`, `fetnet_subject`, `fetnet_teacher`, `fetnet_activity`, `fetnet_activity_planning`, pivot `fetnet_activity_teacher`.
- **`fetnet_activity` final columns:** `program_id`, `planning_id`, `type_id`, `duration`, `active`, `deleted_at`. (No `subject_id`/`semester_id` — they live on planning.)
- **`fetnet_activity_planning`:** `subject_id`, `program_id`, `semester_id`, `deleted_at`.
- **`fetnet_semester`:** `client_id`, `academic_year_id`, `semester` (tinyint 1/2), `name`.
- **`fetnet_academic_year`:** `client_id`, `year_start` (smallint), `is_active`.
- **`fetnet_subject`:** `program_id`, `code`, `name`, `credit` (default 2).
- **`fetnet_teacher`:** `program_id`, `name`, `code`.
- **All models** above use `protected $guarded = []` → mass-assignable.
- **Pivot** attach via `$activity->teachers()->attach($teacherId)`.
- **Trait** `App\Livewire\Concerns\HasProgramSemester` exposes `mountSemesterContext(?int $clientId)`, `loadProgramSemesters()`, `persistSemester()` and public props `$academicYearId`, `$semesterId`, `$academicYearOptions`, `$semesterOptions`.
- **Child component convention in this repo:** co-located, plain filename (no ⚡ prefix), e.g. `import-sheet.blade.php`, referenced `<livewire:pages::path.child />`. Only the index uses `⚡idx`.

### Test DB note
Tests run on sqlite `:memory:` with `RefreshDatabase`. If any migration uses MariaDB-only SQL and fails under sqlite, run the feature test against the docker MariaDB instead:
`docker compose exec -T app php artisan test --filter LecturerWorkloadReport`
(Default command shown in each task assumes sqlite works.)

---

## File Structure

- Create `app/Services/FetNet/LecturerWorkloadReport.php` — recap computation (one responsibility: produce `['programs'=>[], 'rows'=>[]]`).
- Create `tests/Feature/FetNet/LecturerWorkloadReportTest.php` — service behavior.
- Modify `routes/web.php` — add `client.data.workload` route.
- Modify `resources/views/layouts/client.blade.php` — add "Workload" nav item.
- Create `resources/views/pages/client/data/workload/⚡idx.blade.php` — orchestrator page (filters + states).
- Create `resources/views/pages/client/data/workload/workload-table.blade.php` — MaryUI table child.

---

## Task 1: LecturerWorkloadReport service (core happy path)

**Files:**
- Create: `app/Services/FetNet/LecturerWorkloadReport.php`
- Test: `tests/Feature/FetNet/LecturerWorkloadReportTest.php`

- [ ] **Step 1: Write the failing test**

Create `tests/Feature/FetNet/LecturerWorkloadReportTest.php`:

```php
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `php artisan test --filter LecturerWorkloadReportTest`
Expected: FAIL — `Class "App\Services\FetNet\LecturerWorkloadReport" not found`.

- [ ] **Step 3: Write minimal implementation**

Create `app/Services/FetNet/LecturerWorkloadReport.php`:

```php
<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Teacher;
use Illuminate\Support\Facades\DB;

class LecturerWorkloadReport
{
    /**
     * Build the cross-prodi SKS recap for a client's lecturers in the active period.
     *
     * @return array{programs: array<int, array{id:int, abbrev:string, name:string}>,
     *               rows: array<int, array{teacher_id:int, name:string, code:?string,
     *                                       perProgram: array<int,int>, total:int}>}
     */
    public function forClient(Client $client, ?int $activeSemesterId): array
    {
        $empty = ['programs' => [], 'rows' => []];

        $active = $activeSemesterId
            ? Semester::with('academicYear')->find($activeSemesterId)
            : null;

        if (! $active || ! $active->academicYear) {
            return $empty;
        }

        // All semesters system-wide matching the active period (same year_start + parity).
        $periodSemesterIds = Semester::where('semester', $active->semester)
            ->whereHas('academicYear', fn ($q) => $q->where('year_start', $active->academicYear->year_start))
            ->pluck('id');

        $clientProgramIds = Program::where('client_id', $client->id)->pluck('id');
        $clientTeacherIds = Teacher::whereIn('program_id', $clientProgramIds)->pluck('id');

        if ($periodSemesterIds->isEmpty() || $clientTeacherIds->isEmpty()) {
            return $empty;
        }

        // distinct (teacher, prodi, subject, credit) => "per subject once"; team teaching = full credit each.
        $raw = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereIn('at.teacher_id', $clientTeacherIds)
            ->whereNull('a.deleted_at')
            ->whereNull('ap.deleted_at')
            ->distinct()
            ->get(['at.teacher_id', 'a.program_id', 'ap.subject_id', 's.credit']);

        $matrix     = []; // [teacher_id][program_id] => credit sum
        $programIds = [];
        foreach ($raw as $r) {
            $matrix[$r->teacher_id][$r->program_id] =
                ($matrix[$r->teacher_id][$r->program_id] ?? 0) + (int) $r->credit;
            $programIds[$r->program_id] = true;
        }

        if (empty($matrix)) {
            return $empty;
        }

        $programs = Program::whereIn('id', array_keys($programIds))
            ->orderBy('abbrev')
            ->get(['id', 'abbrev', 'name'])
            ->map(fn ($p) => [
                'id'     => $p->id,
                'abbrev' => $p->abbrev ?? '?',
                'name'   => $p->name ?? '',
            ])->values()->toArray();

        $rows = Teacher::whereIn('id', array_keys($matrix))
            ->orderBy('name')
            ->get(['id', 'name', 'code'])
            ->map(fn ($t) => [
                'teacher_id' => $t->id,
                'name'       => $t->name,
                'code'       => $t->code,
                'perProgram' => $matrix[$t->id] ?? [],
                'total'      => array_sum($matrix[$t->id] ?? []),
            ])->values()->toArray();

        return ['programs' => $programs, 'rows' => $rows];
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `php artisan test --filter LecturerWorkloadReportTest`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Services/FetNet/LecturerWorkloadReport.php tests/Feature/FetNet/LecturerWorkloadReportTest.php
git commit -m "feat: lecturer workload recap service with core test"
```

---

## Task 2: Edge cases — cross-client period, per-subject-distinct, team teaching, exclusions

**Files:**
- Modify: `tests/Feature/FetNet/LecturerWorkloadReportTest.php`
- (Service from Task 1 already implements this behavior; these tests lock it in. If any fail, fix the service.)

- [ ] **Step 1: Add the failing/guard tests**

Append these methods inside the `LecturerWorkloadReportTest` class (before the closing brace):

```php
    public function test_counts_cross_client_program_in_matching_period_and_dedupes_subjects(): void
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

        // Home prodi: one subject (3 SKS) split into TWO activities -> counted once = 3.
        $subA = $this->makeSubject($progA, 'CS101', 3);
        $this->makeActivity($progA, $subA, $semA, [$teacher]);
        $this->makeActivity($progA, $subA, $semA, [$teacher]); // split/second activity, same subject

        // Cross-client prodi: subject 2 SKS -> 2.
        $subB = $this->makeSubject($progB, 'EE201', 2);
        $this->makeActivity($progB, $subB, $semB, [$teacher]);

        $report = app(LecturerWorkloadReport::class)->forClient($clientA, $semA->id);

        $abbrevs = array_column($report['programs'], 'abbrev');
        $this->assertContains('CS', $abbrevs);
        $this->assertContains('EE', $abbrevs);

        $row = collect($report['rows'])->firstWhere('name', 'Bob');
        $this->assertSame(3, $row['perProgram'][$progA->id]); // deduped across two activities
        $this->assertSame(2, $row['perProgram'][$progB->id]); // cross-client, matched period
        $this->assertSame(5, $row['total']);
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
```

- [ ] **Step 2: Run the tests**

Run: `php artisan test --filter LecturerWorkloadReportTest`
Expected: PASS (5 tests). If a new test fails, fix `LecturerWorkloadReport` until green (do not weaken the test).

- [ ] **Step 3: Commit**

```bash
git add tests/Feature/FetNet/LecturerWorkloadReportTest.php
git commit -m "test: cover cross-client period, subject dedupe, team teaching, exclusions"
```

---

## Task 3: Route + navigation menu

**Files:**
- Modify: `routes/web.php` (alongside other `client.data.*` routes, near `client.data.activities`)
- Modify: `resources/views/layouts/client.blade.php` (Data group, after Activities item)

- [ ] **Step 1: Add the route**

In `routes/web.php`, immediately after the `client.data.activities` line, add:

```php
    Route::livewire('/client/data/workload',        'pages::client.data.workload.⚡idx')->name('client.data.workload');
```

- [ ] **Step 2: Add the nav item**

In `resources/views/layouts/client.blade.php`, find the Activities anchor block (the `<a href="{{ route('client.data.activities') }}" ...>` with its inner `<span>Activities</span>`). Immediately after that closing `</a>`, add a sibling, matching the existing markup pattern exactly (same `$item`/`$active`/`$dim` classes and span styling used by siblings):

```blade
    <a href="{{ route('client.data.workload') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('client.data.workload') ? $active : $dim }}">
        <x-icon name="o-scale" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Workload</span>
    </a>
```

(If sibling anchors use a different icon element/markup than `<x-icon>`, copy that exact element and only change the icon name to `o-scale` and the label to `Workload`. Keep the icon line consistent with neighbors.)

- [ ] **Step 3: Verify route resolves**

Run: `php artisan route:list --name=client.data.workload`
Expected: one row showing `GET|HEAD client/data/workload ... client.data.workload`.
(If running outside the app container fails on DB, use `docker compose exec -T app php artisan route:list --name=client.data.workload`.)

- [ ] **Step 4: Commit**

```bash
git add routes/web.php resources/views/layouts/client.blade.php
git commit -m "feat: route and nav item for lecturer workload page"
```

---

## Task 4: Workload page orchestrator (`⚡idx`)

**Files:**
- Create: `resources/views/pages/client/data/workload/⚡idx.blade.php`

- [ ] **Step 1: Create the page**

Create `resources/views/pages/client/data/workload/⚡idx.blade.php`:

```blade
<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Client;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Attributes\Layout;
use Livewire\Component;

new #[Layout('layouts.client')] class extends Component
{
    use HasProgramSemester;

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $this->mountSemesterContext($this->client()?->id);
    }

    public function updatedAcademicYearId(): void
    {
        $this->loadProgramSemesters();
        $this->persistSemester();
    }

    public function updatedSemesterId(): void
    {
        $this->persistSemester();
    }

    public function with(): array
    {
        $client = $this->client();

        $report = $client
            ? app(LecturerWorkloadReport::class)->forClient($client, $this->semesterId)
            : ['programs' => [], 'rows' => []];

        return [
            'programs' => $report['programs'],
            'rows'     => $report['rows'],
        ];
    }
}; ?>

<div>
    <x-header title="Lecturer Workload" subtitle="SKS recap across study programs" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                  placeholder="Academic Year" class="w-48" />
        <x-select wire:model.live="semesterId" :options="$semesterOptions"
                  placeholder="Semester" class="w-48" />
    </div>

    @if(! $semesterId)
        <x-alert title="Select a semester to view the workload recap."
                 icon="o-information-circle" class="alert-info" />
    @elseif(count($rows) === 0)
        <x-alert title="No lecturer workload found for this period."
                 icon="o-information-circle" class="alert-info" />
    @else
        <livewire:pages::client.data.workload.workload-table
            :programs="$programs" :rows="$rows" :key="'wt-' . $semesterId" />
    @endif
</div>
```

- [ ] **Step 2: Smoke-check the page renders**

Run: `php artisan view:clear && php artisan route:list --name=client.data.workload`
Expected: no errors; route still listed. (Full visual check happens in Task 6.)

- [ ] **Step 3: Commit**

```bash
git add resources/views/pages/client/data/workload/⚡idx.blade.php
git commit -m "feat: lecturer workload page orchestrator with semester filters"
```

---

## Task 5: Workload table child component

**Files:**
- Create: `resources/views/pages/client/data/workload/workload-table.blade.php`

- [ ] **Step 1: Create the child component**

Create `resources/views/pages/client/data/workload/workload-table.blade.php`:

```blade
<?php

use Livewire\Component;

new class extends Component
{
    /** @var array<int, array{id:int, abbrev:string, name:string}> */
    public array $programs = [];

    /** @var array<int, array{teacher_id:int, name:string, code:?string, perProgram:array<int,int>, total:int}> */
    public array $rows = [];

    public function with(): array
    {
        $headers = array_merge(
            [['key' => 'lecturer', 'label' => 'Lecturer']],
            array_map(fn ($p) => [
                'key'   => 'p_' . $p['id'],
                'label' => $p['abbrev'],
                'class' => 'text-center',
            ], $this->programs),
            [['key' => 'total', 'label' => 'Total', 'class' => 'text-center font-bold']],
        );

        $tableRows = array_map(function ($r) {
            $row = ['lecturer' => $r['name'] . ($r['code'] ? " ({$r['code']})" : '')];
            foreach ($this->programs as $p) {
                $row['p_' . $p['id']] = $r['perProgram'][$p['id']] ?? '';
            }
            $row['total'] = $r['total'];
            return $row;
        }, $this->rows);

        return ['headers' => $headers, 'tableRows' => $tableRows];
    }
}; ?>

<x-card>
    <x-table :headers="$headers" :rows="$tableRows" container-class="overflow-x-auto">
        @foreach($programs as $p)
            @scope('header_p_' . $p['id'], $header)
                <span title="{{ $p['name'] }}">{{ $p['abbrev'] }}</span>
            @endscope
        @endforeach
    </x-table>
</x-card>
```

- [ ] **Step 2: Clear caches**

Run: `php artisan view:clear`
Expected: "Compiled views cleared successfully."

- [ ] **Step 3: Commit**

```bash
git add resources/views/pages/client/data/workload/workload-table.blade.php
git commit -m "feat: workload table child with dynamic prodi columns"
```

---

## Task 6: Manual verification in the running app

**Files:** none (verification only)

- [ ] **Step 1: Ensure stack is up**

Run: `docker compose ps`
Expected: app, mariadb, redis, reverb, worker running.

- [ ] **Step 2: Run the full feature test once more**

Run: `php artisan test --filter LecturerWorkloadReportTest`
Expected: PASS (5 tests).

- [ ] **Step 3: Visual check**

Log in as a client user, open `http://127.0.0.1:8088/client/data/workload`.
Verify:
- "Workload" appears in the Data nav group and is active on this page.
- Academic Year + Semester selectors are populated; changing them updates the table.
- Table shows Lecturer column, one column per prodi that has load (including a prodi from another client if such data exists for the matched period), and a Total column whose value equals the row's per-prodi sum.
- A lecturer with no load does not appear; with no semester selected, the info alert shows.

- [ ] **Step 4: Final commit (if any tweaks were needed)**

```bash
git add -A
git commit -m "chore: verify lecturer workload recap end-to-end"
```

---

## Self-Review Notes

- **Spec coverage:** rows=client dosen (service `clientTeacherIds`), columns=system-wide prodi (no client filter on `a.program_id`), per-subject-distinct (`distinct` incl. `subject_id`), team teaching full credit (no division), active-period cross-client match (`year_start`+`semester` parity), "scheduled"=planned activity (no timetable_slot join), soft-delete excluded, empty states, nav+route, component decomposition (idx + child), MaryUI `x-table`, English-only — all mapped to Tasks 1–6.
- **Types:** `forClient(Client, ?int): array{programs, rows}`; `rows[].perProgram` keyed by program id; child consumes `programs`/`rows` identically. Consistent across tasks.
- **Placeholders:** none.
