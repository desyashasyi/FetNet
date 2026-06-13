# Program Workload Page — Design

**Date:** 2026-06-13
**Page:** Program → Data → Workload (`/program/data/workload`)
**Mirrors:** the client workload page (`/client/data/workload`).

## Goal

Give a program user a per-lecturer SKS workload recap, cross-prodi, for their
program's dosen — same format and rules as the client page, scoped to one program.

## Decisions (identical to client unless noted)

| Topic | Decision |
|-------|----------|
| **Rows** | Dosen whose home `program_id` = the logged-in user's program. |
| **Columns** | Every prodi system-wide where those dosen have load (cross-prodi). Dynamic; only prodi with non-zero load shown. |
| **SKS unit** | Subject `credit`, counted once per (dosen, prodi, subject). |
| **Team teaching** | Full SKS to each dosen. |
| **Period** | Active program semester via `HasProgramSemester` (`mountSemesterContext($program->client_id)`). |
| **Cross-client period match** | year_start + semester parity (same as client). |
| **"Scheduled"** | Assigned to a planned activity (no timetable-slot requirement). |

## Reuse-first architecture

- **Service** `app/Services/FetNet/LecturerWorkloadReport.php`:
  - Extract core `forTeacherIds(\Illuminate\Support\Collection $teacherIds, ?int $activeSemesterId): array`
    containing today's logic (period match → aggregate query → matrix → programs/rows).
  - `forClient(Client, ?int)` becomes a thin wrapper: client program ids → teacher ids → `forTeacherIds`.
  - Add `forProgram(Program, ?int)`: `Teacher::where('program_id', $program->id)->pluck('id')` → `forTeacherIds`.
  - Return shape unchanged: `['programs'=>[], 'rows'=>[]]`. Existing client behavior/tests stay green.
- **Child component** is reused as-is: the program page renders the existing presentational
  `<livewire:pages::client.data.workload.workload-table :programs :rows :key />` (props-only, role-agnostic).

## Page

`resources/views/pages/program/data/workload/⚡idx.blade.php` (layout `program`):
- `program()` = `Program::where('user_id', auth()->id())->first()`.
- `mount()` → `if ($program) $this->mountSemesterContext($program->client_id);`
- `updatedAcademicYearId()` → `loadProgramSemesters(); persistSemester();`
- `updatedSemesterId()` → `persistSemester();`
- `with()` → `forProgram($program, $this->semesterId)`; returns `programs`, `rows`.
- Markup mirrors client idx: `x-header`, AY + semester `x-select`, empty states
  ("Select a semester…", "No lecturer workload found for this period."), then the
  reused `workload-table` child keyed by `'wt-'.$semesterId`.

## Routing & Nav

- `routes/web.php` (program group): `Route::livewire('/data/workload', 'pages::program.data.workload.⚡idx')->name('data.workload');`
- `resources/views/layouts/program.blade.php`: add a "Workload" anchor in the Data group
  after Activities, icon `o-scale`, active state via `request()->routeIs('program.data.workload')`,
  matching sibling markup.

## Testing

- Service `forProgram` test (sqlite + RefreshDatabase): a program's dosen as rows; a dosen
  who also teaches in another program (matching period) shows both prodi columns + correct total.
- Authenticated page-render test: acting as the program's user, GET `/program/data/workload`
  returns 200 and shows the header + a seeded lecturer + a prodi column.
- Existing client workload tests must remain green after the service refactor.

## Out of Scope (YAGNI)

- Excel export, per-subject drill-down, program-only single-column mode.
