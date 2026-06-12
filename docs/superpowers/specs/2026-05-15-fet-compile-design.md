# Compile FET File from Database — Design

**Date:** 2026-05-15
**Status:** Draft, pending implementation plan

## 1. Purpose

Allow a client (institution) user to compile every relevant database entity for a given semester into a downloadable FET file (`.fet`, XML format used by [Free Timetabling Software](https://lalescu.ro/liviu/fet/)). The compiled file becomes the input artifact for a later "Generate Timetable" feature that runs the FET solver and stores the resulting timetable back into the database.

Scope of this design: **only the database → `.fet` compile step**. The solver-run step is a separate future spec.

## 2. Scope and constraints

- **Owner of output:** one `.fet` file per `Client` (whole institution), not per `Program` or `Cluster`. A client owns many programs, and the FET solver works best when all shared resources (rooms, guest teachers, cross-cluster activities) live in one file.
- **Semester scope:** one compile run is bound to a single `Semester` (which already pins an `AcademicYear`). The user picks the active semester at compile time; default is the session-current semester.
- **Constraint coverage:** all constraint tables are translated — `TeacherConstraint`, `StudentConstraint`, `TeacherTimeConstraint`, `StudentTimeConstraint`, `ActivityTimeConstraint`. Both time and space constraints emit.
- **Trigger UI:** new page `resources/views/pages/client/timetable/⚡idx.blade.php`, accessible only to client-role users. Two buttons:
  - `Compile FET` — produces a new `.fet` file (this spec).
  - `Generate Timetable` — placeholder, disabled unless a successful FET compile exists for the chosen semester (later spec).
- **Output delivery:** save to `storage/app/fet/{clientId}/{timestamp}_{semesterId}.fet`, broadcast event with download URL, show toast + refresh history table.
- **Compile must not block UI.** Job runs on the `default` queue.

## 3. Non-goals

- Reading a FET file back into the database.
- Running the FET solver.
- Per-program or per-cluster compile.
- Streaming / synchronous download.

## 4. Architecture

```
┌──────────────────────────────────┐
│ pages/client/timetable/⚡idx     │
│  - Compile FET btn               │
│  - Generate Timetable btn        │
│  - History table (FetCompile)    │
└───────────┬──────────────────────┘
            │ event(new CompileFetRequestedEvent(clientId, semesterId, userId))
            ▼
┌──────────────────────────────────┐
│ Listener CompileFetOnRequest     │
│  dispatch CompileFetJob          │
└───────────┬──────────────────────┘
            ▼
┌──────────────────────────────────┐
│ Job CompileFetJob (ShouldQueue)  │
│  1. row FetCompile status=pending│
│  2. xml = FetXmlBuilder->build() │
│  3. Storage::put path            │
│  4. row update status=success    │
│  5. broadcast FetCompiledEvent   │
└───────────┬──────────────────────┘
            ▼
        echo channel
   fet-compile.{clientId}
            ▼
┌──────────────────────────────────┐
│ Livewire echo listener           │
│  refresh history, toast, enable  │
│  Generate Timetable button       │
└──────────────────────────────────┘
```

### 4.1 Components

| File | Type | Responsibility |
|---|---|---|
| `app/Events/FetNet/CompileFetRequestedEvent.php` | event (not broadcast) | Carries `clientId`, `semesterId`, `userId` |
| `app/Listeners/CompileFetOnRequest.php` | listener | Dispatches `CompileFetJob` |
| `app/Jobs/FetNet/CompileFetJob.php` | queued job | Orchestrates compile and persistence |
| `app/Services/FetNet/FetXmlBuilder.php` | service | Pure builder, returns XML string |
| `app/Services/FetNet/Sections/*.php` | section builders | One file per FET top-level section |
| `app/Events/FetNet/FetCompiledEvent.php` | event (broadcast) | Notify Livewire on done/fail |
| `app/Models/FetNet/FetCompile.php` | Eloquent model | History row |
| `database/migrations/..._create_fetnet_fet_compile_table.php` | migration | History table |
| `resources/views/pages/client/timetable/⚡idx.blade.php` | Livewire 4 page | Trigger UI + history |
| `resources/views/pages/client/timetable/compile-history-card.blade.php` | child component | List rows from FetCompile |

### 4.2 Service decomposition

`FetXmlBuilder` is the single public entry point: `build(Client $client, Semester $semester): string`. Internally it streams XML via PHP `XMLWriter` and delegates each FET section to a dedicated builder class for readability and unit-testability:

- `DaysSectionBuilder` — reads `ClientConfig.days` (fallback Mon–Fri).
- `HoursSectionBuilder` — reads `ClientConfig.hours`, computes slot list from start/end/slot-length.
- `SubjectsSectionBuilder` — `Subject` rows in `client_id`.
- `ActivityTagsSectionBuilder` — `ActivityTag` rows in `client_id`.
- `TeachersSectionBuilder` — `Teacher` rows in `client_id` + qualified subjects join.
- `StudentsSectionBuilder` — walks the self-referential `Student` tree (`parent_id` is null at the Year root, then Group, then Subgroup) per `Program`. `CurriculumYear` and `Specialization` belong to the subject side and are **not** emitted as student groupings.
- `BuildingsRoomsSectionBuilder` — `Building` + `Space` rows in `client_id`.
- `ActivitiesSectionBuilder` — `Activity` rows with `SubActivity` splits.
- `TimeConstraintsSectionBuilder` — translates all `*TimeConstraint` rows.
- `SpaceConstraintsSectionBuilder` — translates all `*Constraint` rows (room preferences).

Each section builder receives the open `XMLWriter` and the relevant Eloquent collection; no section accesses the database itself — `FetXmlBuilder` loads everything once with eager loading, then passes data down.

### 4.3 Data loading strategy

Load all entities up-front in `FetXmlBuilder::build()`:

```php
$subjects   = Subject::where('client_id', $client->id)->orderBy('code')->get();
$teachers   = Teacher::where('client_id', $client->id)
                ->with(['subjects:id,code'])
                ->orderBy('code')->get();
$programs   = Program::where('client_id', $client->id)->orderBy('abbrev')->get();
$students   = Student::whereIn('program_id', $programs->pluck('id'))
                ->with(['children.children'])      // Year → Group → Subgroup
                ->whereNull('parent_id')           // load only roots; descendants come via eager 'children.children'
                ->orderBy('name')->get();
$buildings  = Building::where('client_id', $client->id)->with('spaces')->orderBy('code')->get();
$tags       = ActivityTag::where('client_id', $client->id)->get();
$activities = Activity::where('client_id', $client->id)
                ->where('semester_id', $semester->id)
                ->with(['subject:id,code', 'subActivities', 'teachers:id,code', 'tags:id,name', 'spaces:id,code'])
                ->get();
$ttc        = TeacherTimeConstraint::whereIn('teacher_id', $teacherIds)->where('semester_id', $semester->id)->get();
// ... similar for stc, atc, tc, sc
```

If a client grows past a few thousand activities, switch to `chunk()` per section. Initial implementation eager-loads to keep the design simple.

### 4.4 FetCompile table schema

```
id          : bigint pk
client_id   : fk fetnet_client (cascade on delete)
semester_id : fk fetnet_semester
user_id     : fk users (who triggered)
path        : string (relative storage path)
size_bytes  : unsigned bigint nullable
status      : enum('pending','success','failed') default 'pending'
message     : text nullable          // error reason or summary line
duration_ms : unsigned int nullable
created_at  : timestamp
updated_at  : timestamp
```

History older than the last N rows per client is **kept**, not pruned, until a retention spec is written.

### 4.5 Failure handling

- `CompileFetJob` wraps the build call in `try/catch`. On exception: update row to `status=failed`, set `message` to exception summary, broadcast `FetCompiledEvent` with `status='failed'`. Do not rethrow — failed runs are not job-level errors, they are domain errors the user must see.
- Storage write failure is treated identically.
- If the entire job process dies (server kill, OOM), the row stays at `status=pending` and a follow-up reconciliation task may sweep stale rows (out of scope here).

### 4.6 Concurrency

Only one compile per (`client_id`, `semester_id`) may run at once. Before dispatching the job, the listener checks whether a `pending` row exists for that pair and refuses with a flash toast if so. The lock is advisory at the listener level; the job itself does not re-check.

## 5. UI

Page `pages/client/timetable/⚡idx.blade.php`:

```
[ Compile FET ]   [ Generate Timetable (disabled) ]   semester: <x-choices>

x-table history:
  Time | Semester | Size | Status | Action
  ──────────────────────────────────────────
  ...   ...        12 KB  success  [Download]
```

Echo listener: `echo:fet-compile.{clientId},.FetCompiledEvent` → refresh `#[Computed] compiles`, toast, re-render.

## 6. Open questions

None at this point. All four brainstorm questions answered:

- Scope: Per Client.
- Trigger: `/client/timetable` page.
- Output: storage + broadcast download.
- Constraints: all.

## 7. Future feature: Generate Timetable + lock editing (separate spec)

Out of scope for the current compile step, but the architecture must leave hooks for it.

### 7.1 Storage

After "Generate Timetable" runs the FET solver, store the result in a new table:

```
fetnet_timetable_slot
  id          : bigint pk
  client_id   : fk fetnet_client
  semester_id : fk fetnet_semester
  activity_id : fk fetnet_activity (unique per semester)
  day         : tinyint  (1..number_of_days)
  hour        : tinyint  (1..number_of_hours)
  locked      : boolean default false   ← maps to FET <Permanently_Locked>
  active      : boolean default true    ← maps to FET <Active>
  weight      : decimal(5,2) default 100.00 ← maps to <Weight_Percentage>
  source      : enum('solver','manual') default 'solver'
  generation_id : fk fetnet_fet_compile (which run produced this row)
  timestamps
```

### 7.2 Lock semantics (verified against FET v6.24.0 sample + docs)

Each row emits one block inside `<Time_Constraints_List>`:

```xml
<ConstraintActivityPreferredStartingTime>
  <Weight_Percentage>{weight}</Weight_Percentage>
  <Activity_Id>{activity_id}</Activity_Id>
  <Preferred_Day>{day_name}</Preferred_Day>
  <Preferred_Hour>{hour_name}</Preferred_Hour>
  <Permanently_Locked>{locked ? true : false}</Permanently_Locked>
  <Active>{active ? true : false}</Active>
  <Comments></Comments>
</ConstraintActivityPreferredStartingTime>
```

- `Permanently_Locked=true` ⇒ FET cannot move the activity from (day, hour) during re-solve.
- `Permanently_Locked=false` ⇒ preferred but moveable.
- `Active=false` ⇒ constraint stored but ignored by solver (allows quick toggle in dashboard).

### 7.3 Compile-honors-locks rule

**Even the current first-pass compile must read `fetnet_timetable_slot`** and emit one `ConstraintActivityPreferredStartingTime` block per row whose `active=true`. On first ever compile no rows exist, so nothing extra emits. After Generate Timetable runs once, subsequent compiles automatically carry the locked slots forward. This is what makes the FET-Desktop-style lock workflow possible.

⇒ Add `TimetableSlotsConstraintBuilder` to the `Sections/` directory as part of `TimeConstraintsSectionBuilder` or its own sibling section. It is wired now (no-op until table is populated) so the future Generate Timetable feature only needs to write rows, not change the builder.

### 7.4 Edit UI (future)

- Page `pages/client/timetable/edit/⚡idx.blade.php` lists `fetnet_timetable_slot` rows by activity, lets user toggle `locked`, `active`, edit `day/hour`, `weight`.
- "Re-Generate" button = call Compile FET again (which now picks up the locked rows) then dispatch the solver job.

## 8. Out-of-scope / later specs

- Running the FET CLI solver and parsing its output back into `fetnet_timetable_slot`.
- The Edit page UI of §7.4.
- Retention/pruning of old FetCompile rows + storage cleanup.
- Validation pass that verifies the produced `.fet` opens cleanly in FET (`fet-cl --inputfile=...`).
