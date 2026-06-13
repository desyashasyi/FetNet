# Lecturer Workload Recap (Cross-Prodi) — Design

**Date:** 2026-06-13
**Area:** Client → Data
**Route:** `client.data.workload` → `/client/data/workload`

## Goal

Add a menu under **Data** (`/client/data`) that recaps lecturer (dosen) teaching
load across all study programs (prodi), including load incurred when a dosen is
scheduled in another prodi.

Output format: **dosen name, SKS per prodi, total load**.

## Decisions

| Topic | Decision |
|-------|----------|
| **Rows** | This client's dosen — teachers whose home `program_id` belongs to a program under the logged-in client. |
| **Columns (prodi counted)** | System-wide. Any prodi (including other clients/faculties) where the listed dosen have load. Columns are **dynamic**: only prodi with non-zero load appear. |
| **SKS unit** | Subject `credit`, counted **per activity** — a subject split into several activities (theory + lab) is counted once per activity. |
| **Team teaching** | Full SKS credited to **each** dosen on the activity (no split). |
| **Period** | Active selected semester (shared `HasProgramSemester` context). |
| **Cross-client semester match** | Semester is client-scoped. For system-wide scope, the active period is matched by **(academicYear.year_start + semester number 1/2)** across all clients. |
| **"Scheduled" meaning** | Dosen assigned to a *planned activity* in that prodi for the period. Timetable-slot placement is **not** required. |

## Data Model (verified)

- `AcademicYear`: `client_id`, `year_start` (smallint, e.g. 2024 = "2024/2025").
- `Semester`: `client_id`, `academic_year_id`, `semester` (tinyint 1/2), `start_month`, `end_month`.
- `ActivityPlanning`: `subject_id`, `program_id`, `semester_id`; soft-deletes. Relations: `subject`, `program`, `semester`.
- `Activity`: `program_id`, `planning_id`; soft-deletes. Relations: `program`, `planning`, `teachers` (M2M `fetnet_activity_teacher`).
- `Subject`: `credit`, `program_id`.
- `Teacher`: `program_id` (home), `activities()` M2M.
- `Program`: `client_id`, `abbrev`, `name`.

## Data Flow

1. Resolve `client` from `auth()->id()`. Resolve active `academicYearId` + `semesterId`
   via the `HasProgramSemester` trait (AY + semester dropdowns, consistent with other
   Data pages; this page is a follower that may also change the shared session context).
2. From the active `Semester`, read its `semester` number (1/2) and its
   `academicYear.year_start`.
3. Compute `$periodSemesterIds` — all `Semester` ids system-wide where
   `semester = <activeNumber>` AND `academicYear.year_start = <activeYearStart>`.
   ```php
   $periodSemesterIds = Semester::where('semester', $activeNum)
       ->whereHas('academicYear', fn ($q) => $q->where('year_start', $activeYearStart))
       ->pluck('id');
   ```
4. `$clientTeacherIds` — teachers whose `program_id` is in the client's program ids.
5. Single aggregate query:
   ```php
   $rows = DB::table('fetnet_activity as a')
       ->join('fetnet_activity_teacher as at', 'at.activity_id', '=', 'a.id')
       ->join('fetnet_activity_planning as ap', 'ap.id', '=', 'a.planning_id')
       ->join('fetnet_subject as s', 's.id', '=', 'ap.subject_id')
       ->whereIn('ap.semester_id', $periodSemesterIds)
       ->whereIn('at.teacher_id', $clientTeacherIds)
       ->whereNull('a.deleted_at')
       ->whereNull('ap.deleted_at')
       ->distinct()
       ->select('a.id as activity_id', 'at.teacher_id', 'a.program_id', 's.credit')
       ->get();
   ```
   One row per (activity, teacher) — counts each activity's subject credit (`distinct`
   on the activity id guards duplicate teacher pivot rows). Aggregate in PHP:
   `matrix[teacher_id][program_id] += credit`; `total[teacher_id] += credit`.
   - Confirm actual table names against migrations before coding (e.g. `fetnet_activity_planning`).
6. Lookups: `Teacher::whereIn('id', ...)` for name + code; `Program::whereIn('id', ...)`
   for `abbrev` (+ `name` for tooltip). Column set = sorted union of `program_id`s present.

## Components (per fetnet-component-decomposition)

- `resources/views/pages/client/data/workload/⚡idx.blade.php` — orchestrator:
  page header (`x-page-header`/`x-header` per existing pages), AY + semester filters,
  empty states (no semester selected / no data), renders the table child.
- `resources/views/pages/client/data/workload/⚡workload-table.blade.php` — co-located
  child: MaryUI `x-table` with a fixed **Dosen** column, one dynamic column per prodi
  (`abbrev`), and a trailing **Total** column. Dosen with zero load are hidden.
  Optional bottom totals row per prodi.

All UI uses MaryUI (`x-*`) components; all text English-only.

## Navigation

Add a "Workload" item in `resources/views/layouts/client.blade.php` within the **Data**
group, after Activities, linking `route('client.data.workload')` with active-state
handling matching siblings.

## Routing

Add to `routes/web.php` alongside the other `client.data.*` livewire routes:
```php
Route::livewire('/client/data/workload', 'pages::client.data.workload.⚡idx')
    ->name('client.data.workload');
```

## Edge Cases

- **No active semester / no academic year:** show an empty state prompting selection.
- **No data for period:** show empty state ("No workload for this period").
- **Dosen with zero load:** hidden from rows.
- **Prodi abbrev collisions across clients:** acceptable; abbrev only (name in tooltip).
- **Soft-deleted activities/plannings:** excluded via `deleted_at` null filters.

## Out of Scope (YAGNI)

- Excel/PDF export.
- Per-subject drill-down.
- Hour/duration-based load view.
- Distinguishing home vs guest prodi visually.

## Testing

- Seeded scenario: dosen of client A teaching in own prodi + in a prodi of client B
  whose semester shares the same year_start + odd/even number → both columns populate,
  total = sum.
- Subject with 2 activities (split) for same dosen+prodi → counted once.
- Two dosen on one activity → both get full credit.
- Activity in a different period (different year_start or opposite parity) → excluded.
- Soft-deleted activity → excluded.
