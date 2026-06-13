# Program Workload Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `/program/data/workload` — a per-lecturer cross-prodi SKS recap for the logged-in program's dosen, mirroring the client workload page.

**Architecture:** Refactor `LecturerWorkloadReport` to a shared `forTeacherIds()` core with thin `forClient()`/`forProgram()` wrappers; add a Livewire 4 SFC page under `program/data/workload` that reuses the existing presentational `client.data.workload.workload-table` child.

**Tech Stack:** Laravel 12, Livewire 4 (SFC), MaryUI, PHPUnit 11, sqlite `:memory:` tests.

---

## Reference Facts (verified)

- Client workload service: `app/Services/FetNet/LecturerWorkloadReport.php`, method `forClient(Client $client, ?int $activeSemesterId): array` returning `['programs'=>[...], 'rows'=>[...]]`.
- Reusable child: `resources/views/pages/client/data/workload/workload-table.blade.php` — public `array $programs`, `array $rows`; props-only, role-agnostic.
- Program page scoping pattern (`pages/program/data/activities/⚡idx.blade.php`): `Program::where('user_id', auth()->id())->first()`, then `$this->mountSemesterContext($program->client_id)`.
- Trait `App\Livewire\Concerns\HasProgramSemester`: `mountSemesterContext(?int $clientId)`, `loadProgramSemesters()`, `persistSemester()`, public `$academicYearId`, `$semesterId`, `$academicYearOptions`, `$semesterOptions`.
- `Teacher` has `program_id`; `Program` model table `institution_program`, `$guarded=[]`, has `client_id`, `user_id`, `abbrev`, `name`.
- Program routes live in `routes/web.php` under `Route::middleware(['auth'])->prefix('program')->name('program.')->group(...)`, names like `data.activities` (full name `program.data.activities`).
- Program nav: `resources/views/layouts/program.blade.php`, Data group; Activities anchor uses `route('program.data.activities')`, `request()->routeIs('program.data.activities')`, icon `o-table-cells`.
- Tests run sqlite `:memory:` + `RefreshDatabase`; existing helpers/pattern in `tests/Feature/FetNet/LecturerWorkloadReportTest.php` and `WorkloadPageRenderTest.php`.
- All test commands run inside the container: `docker compose exec -T app php artisan test --filter <Name>`.

---

## File Structure

- Modify `app/Services/FetNet/LecturerWorkloadReport.php` — extract `forTeacherIds()` core; `forClient()` wrapper; add `forProgram()`.
- Create `resources/views/pages/program/data/workload/⚡idx.blade.php` — program workload page (filters + states + reused child).
- Modify `routes/web.php` — add `program.data.workload` route.
- Modify `resources/views/layouts/program.blade.php` — add "Workload" nav item.
- Modify `tests/Feature/FetNet/LecturerWorkloadReportTest.php` — add `forProgram` test.
- Create `tests/Feature/FetNet/ProgramWorkloadPageRenderTest.php` — authenticated render test.

---

## Task 1: Refactor service to `forTeacherIds` core + add `forProgram`

**Files:**
- Modify: `app/Services/FetNet/LecturerWorkloadReport.php`
- Test: `tests/Feature/FetNet/LecturerWorkloadReportTest.php`

- [ ] **Step 1: Write the failing test**

Append this method inside the `LecturerWorkloadReportTest` class (before the final closing brace). It reuses the existing private helpers (`makeClient`, `makeProgram`, `makeSemester`, `makeSubject`, `makeActivity`) already defined in that file:

```php
    public function test_for_program_rows_are_program_teachers_with_cross_prodi_columns(): void
    {
        $client   = $this->makeClient();
        $progA    = $this->makeProgram($client, 'CS');
        $semA     = $this->makeSemester($client, 2024, 1);
        $teacher  = \App\Models\FetNet\Teacher::create(['program_id' => $progA->id, 'name' => 'Bob', 'code' => 'BOB']);

        // Same client, another program with a matching-period semester.
        $progB    = $this->makeProgram($client, 'EE');
        $semB     = $this->makeSemester($client, 2024, 1);

        // Teacher of progA teaches in progA (3 SKS) and in progB (2 SKS).
        $subA = $this->makeSubject($progA, 'CS101', 3);
        $this->makeActivity($progA, $subA, $semA, [$teacher]);
        $subB = $this->makeSubject($progB, 'EE201', 2);
        $this->makeActivity($progB, $subB, $semB, [$teacher]);

        // A teacher NOT in progA must not appear as a row.
        $other = \App\Models\FetNet\Teacher::create(['program_id' => $progB->id, 'name' => 'Zed', 'code' => 'ZED']);
        $subZ  = $this->makeSubject($progB, 'EE301', 4);
        $this->makeActivity($progB, $subZ, $semB, [$other]);

        $report = app(\App\Services\FetNet\LecturerWorkloadReport::class)->forProgram($progA, $semA->id);

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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -T app php artisan test --filter LecturerWorkloadReportTest`
Expected: FAIL — `Method ... forProgram() does not exist` (or BadMethodCall) on the new test; the other tests still pass.

- [ ] **Step 3: Refactor the service**

Replace the entire body of `app/Services/FetNet/LecturerWorkloadReport.php` with:

```php
<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Teacher;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class LecturerWorkloadReport
{
    /** Recap for a client's lecturers (home program under the client). */
    public function forClient(Client $client, ?int $activeSemesterId): array
    {
        $programIds = Program::where('client_id', $client->id)->pluck('id');
        $teacherIds = Teacher::whereIn('program_id', $programIds)->pluck('id');

        return $this->forTeacherIds($teacherIds, $activeSemesterId);
    }

    /** Recap for a single program's lecturers (home program = this program). */
    public function forProgram(Program $program, ?int $activeSemesterId): array
    {
        $teacherIds = Teacher::where('program_id', $program->id)->pluck('id');

        return $this->forTeacherIds($teacherIds, $activeSemesterId);
    }

    /**
     * Core: cross-prodi SKS recap for a set of lecturers in the active period.
     *
     * @param  Collection<int, int>  $teacherIds
     * @return array{programs: array<int, array{id:int, abbrev:string, name:string}>,
     *               rows: array<int, array{teacher_id:int, name:string, code:?string,
     *                                       perProgram: array<int,int>, total:int}>}
     */
    public function forTeacherIds(Collection $teacherIds, ?int $activeSemesterId): array
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

        if ($periodSemesterIds->isEmpty() || $teacherIds->isEmpty()) {
            return $empty;
        }

        // distinct (teacher, prodi, subject, credit) => "per subject once"; team teaching = full credit each.
        $raw = DB::table('fetnet_activity as a')
            ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
            ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
            ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
            ->whereIn('ap.semester_id', $periodSemesterIds)
            ->whereIn('at.teacher_id', $teacherIds)
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

- [ ] **Step 4: Run tests to verify they pass**

Run: `docker compose exec -T app php artisan test --filter LecturerWorkloadReportTest`
Expected: PASS (6 tests — the 5 existing + the new `for_program` test).

- [ ] **Step 5: Verify client page render test still passes**

Run: `docker compose exec -T app php artisan test --filter WorkloadPageRenderTest`
Expected: PASS (1 test).

- [ ] **Step 6: Commit**

```bash
git add app/Services/FetNet/LecturerWorkloadReport.php tests/Feature/FetNet/LecturerWorkloadReportTest.php
git commit -m "refactor: extract forTeacherIds core; add forProgram to workload report"
```

---

## Task 2: Route + navigation menu

**Files:**
- Modify: `routes/web.php` (program group, after `data.activities`)
- Modify: `resources/views/layouts/program.blade.php` (Data group, after Activities)

- [ ] **Step 1: Add the route**

In `routes/web.php`, immediately after the line registering `data.activities` (`Route::livewire('/data/activities', 'pages::program.data.activities.⚡idx')->name('data.activities');`), add:

```php
    Route::livewire('/data/workload',       'pages::program.data.workload.⚡idx')->name('data.workload');
```

- [ ] **Step 2: Add the nav item**

In `resources/views/layouts/program.blade.php`, find the Activities anchor:

```blade
    <a href="{{ route('program.data.activities') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.activities') ? $active : $dim }}">
        <x-icon name="o-table-cells" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Activities</span>
    </a>
```

Immediately after its closing `</a>`, add:

```blade
    <a href="{{ route('program.data.workload') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.workload') ? $active : $dim }}">
        <x-icon name="o-scale" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Workload</span>
    </a>
```

(If the Activities anchor's inner markup differs from the block above, copy that exact markup and change only the route name to `program.data.workload`, the icon to `o-scale`, and the label to `Workload`.)

- [ ] **Step 3: Verify route resolves**

Run: `docker compose exec -T app php artisan route:list --name=program.data.workload`
Expected: one row: `GET|HEAD program/data/workload ... program.data.workload`.

- [ ] **Step 4: Commit**

```bash
git add routes/web.php resources/views/layouts/program.blade.php
git commit -m "feat: route and nav item for program workload page"
```

---

## Task 3: Program workload page (`⚡idx`)

**Files:**
- Create: `resources/views/pages/program/data/workload/⚡idx.blade.php`

- [ ] **Step 1: Create the page**

Create `resources/views/pages/program/data/workload/⚡idx.blade.php`:

```blade
<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Program;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Attributes\Layout;
use Livewire\Component;

new #[Layout('layouts.program')] class extends Component
{
    use HasProgramSemester;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $program = $this->program();
        if ($program) {
            $this->mountSemesterContext($program->client_id);
        }
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
        $program = $this->program();

        $report = $program
            ? app(LecturerWorkloadReport::class)->forProgram($program, $this->semesterId)
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

- [ ] **Step 2: Clear caches + verify route still lists**

Run: `docker compose exec -T app php artisan view:clear && docker compose exec -T app php artisan route:list --name=program.data.workload`
Expected: "Compiled views cleared…" and the route row.

- [ ] **Step 3: Commit**

```bash
git add resources/views/pages/program/data/workload/⚡idx.blade.php
git commit -m "feat: program workload page reusing client workload table"
```

---

## Task 4: Authenticated page render test

**Files:**
- Create: `tests/Feature/FetNet/ProgramWorkloadPageRenderTest.php`

- [ ] **Step 1: Write the test**

Create `tests/Feature/FetNet/ProgramWorkloadPageRenderTest.php`:

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
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProgramWorkloadPageRenderTest extends TestCase
{
    use RefreshDatabase;

    public function test_program_workload_page_renders_for_program_user(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'CS', 'name' => 'CS Program']);

        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2024, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Odd']);
        $teacher = Teacher::create(['program_id' => $program->id, 'name' => 'Alice', 'code' => 'ALC']);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'CS101', 'name' => 'Intro', 'credit' => 3]);

        $planning = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $activity = Activity::create(['program_id' => $program->id, 'planning_id' => $planning->id, 'duration' => 2, 'active' => true]);
        $activity->teachers()->attach($teacher->id);

        $response = $this->actingAs($user)->get('/program/data/workload');

        $response->assertOk();
        $response->assertSee('Lecturer Workload');
        $response->assertSee('Alice');
        $response->assertSee('CS'); // prodi column header
    }
}
```

- [ ] **Step 2: Run the test**

Run: `docker compose exec -T app php artisan test --filter ProgramWorkloadPageRenderTest`
Expected: PASS (1 test). The `/program` route group uses only `auth` middleware (no role), so acting as the program user is sufficient.

- [ ] **Step 3: Commit**

```bash
git add tests/Feature/FetNet/ProgramWorkloadPageRenderTest.php
git commit -m "test: render program workload page for program user"
```

---

## Task 5: Full verification

**Files:** none (verification only)

- [ ] **Step 1: Run all workload-related tests**

Run: `docker compose exec -T app php artisan test --filter "Workload|LecturerWorkload"`
Expected: PASS — `LecturerWorkloadReportTest` (6), `WorkloadPageRenderTest` (1), `ProgramWorkloadPageRenderTest` (1).

- [ ] **Step 2: Visual check**

Log in as a program user, open `http://127.0.0.1:8088/program/data/workload`. Verify:
- "Workload" appears in the program Data nav group and is active here.
- AY + Semester selectors populate; changing them updates the table.
- Rows are this program's dosen; columns include any other prodi where they have load; Total = row sum.
- No semester selected → info alert; no data → "No lecturer workload found for this period."

---

## Self-Review Notes

- **Spec coverage:** service reuse via `forTeacherIds` + `forProgram` (Task 1); cross-prodi rows/columns, per-subject-distinct, team-teach, period match all inherited from the unchanged core; route + nav (Task 2); page with program scoping, `mountSemesterContext($program->client_id)`, reused `workload-table` child, empty states (Task 3); program render test (Task 4); client tests stay green (Task 1 steps 4–5). All mapped.
- **Types:** `forTeacherIds(Collection, ?int): array{programs, rows}`; `forClient`/`forProgram` delegate to it; page consumes `programs`/`rows`; child props `programs`/`rows` unchanged.
- **Placeholders:** none.
