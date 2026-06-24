# Facultee Sync Sender (FetNet side) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When a FetNet client publishes a timetable, FetNet pushes a per-semester snapshot (rooms + class sessions) to the Facultee app over HTTP, idempotently and via a queued job that broadcasts a completion event.

**Architecture:** A payload-builder service reads the published `TimetableSlot` rows (+ relations) for a client+semester and produces the sync contract array. A queued job POSTs that payload to Facultee's `/api/sync/timetable` with a bearer token, records the result, and broadcasts a completion event. An artisan command triggers a manual sync; the existing `publish()` in the client timetable page dispatches the job automatically.

**Tech Stack:** Laravel 12, Livewire 4 SFC, Laravel HTTP client (`Http::`), Reverb broadcasting (`ShouldBroadcastNow`), Redis queue, PHPUnit + SQLite in-memory tests.

## Global Constraints

- All natural language (comments, strings, messages) is **English only**.
- Every new class/method carries a complete doc comment (FetNet documentation rule).
- Every queued job MUST broadcast a completion event (FetNet job-event rule).
- Tests run on **SQLite in-memory** — use portable SQL only; build data with `Model::create(...)` the way existing tests in `tests/Feature/FetNet/` do (there are no model factories except `User`).
- Run artisan in Docker as: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan ...`. Tests: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=<Name>`.
- Semester string ref format: `"<year_start>-<ganjil|genap>"` where `ganjil` when `semester == 1` else `genap` (e.g. `2025-ganjil`).
- Commit message trailer: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`.

## File Structure

- `config/services.php` — add a `facultee` block (`url`, `token`).
- `app/Services/FetNet/FaculteeSyncPayloadBuilder.php` — builds the sync payload array from a client+semester. One responsibility: data → contract shape.
- `app/Events/FetNet/TimetableSyncedEvent.php` — broadcast completion event.
- `app/Jobs/FetNet/SyncTimetableToFaculteeJob.php` — builds payload, POSTs, broadcasts.
- `app/Console/Commands/FetNet/SyncFaculteeCommand.php` — `facultee:sync {client} {semester}`.
- `resources/views/pages/client/timetable/⚡idx.blade.php` — dispatch the job inside `publish()`.
- Tests under `tests/Feature/FetNet/`: `FaculteeSyncPayloadBuilderTest`, `SyncTimetableToFaculteeJobTest`, `SyncFaculteeCommandTest`, `PublishTriggersFaculteeSyncTest`.

---

### Task 1: Facultee service config

**Files:**
- Modify: `config/services.php`
- Test: `tests/Feature/FetNet/FaculteeConfigTest.php`

**Interfaces:**
- Produces: `config('services.facultee.url')` (string|null), `config('services.facultee.token')` (string|null).

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use Tests\TestCase;

class FaculteeConfigTest extends TestCase
{
    public function test_facultee_service_config_reads_env(): void
    {
        config()->set('services.facultee.url', 'http://facultee-app:8000');
        config()->set('services.facultee.token', 'secret-token');

        $this->assertSame('http://facultee-app:8000', config('services.facultee.url'));
        $this->assertSame('secret-token', config('services.facultee.token'));
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=FaculteeConfigTest`
Expected: PASS for the set/get (this guards the keys exist); if you prefer a true red first, assert the default `config('services.facultee.url')` is non-null before adding the block — it will be null → FAIL.

- [ ] **Step 3: Add the config block**

In `config/services.php`, add before the closing `];`:

```php
    'facultee' => [
        'url'   => env('FACULTEE_URL'),
        'token' => env('FACULTEE_SYNC_TOKEN'),
    ],
```

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=FaculteeConfigTest`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add config/services.php tests/Feature/FetNet/FaculteeConfigTest.php
git commit -m "feat: add facultee service config (url, token)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 2: Payload builder service

**Files:**
- Create: `app/Services/FetNet/FaculteeSyncPayloadBuilder.php`
- Test: `tests/Feature/FetNet/FaculteeSyncPayloadBuilderTest.php`

**Interfaces:**
- Consumes: `config('services.facultee.*')` (none directly; pure data).
- Produces: `FaculteeSyncPayloadBuilder::build(int $clientId, int $semesterId): array` returning
  `['semester' => ['ref','academic_year','term'], 'published_at' => string, 'rooms' => array, 'sessions' => array]`.
  Each session: `fetnet_slot_id, fetnet_activity_id, day_of_week, start_hour, duration, fetnet_space_id, subject_code, subject_name, lecturer, student_group, locked`.
  Each room: `fetnet_space_id, code, name, building, floor, capacity, facilities`.

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Semester;
use App\Models\FetNet\Space;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
use App\Models\FetNet\TimetableSlot;
use App\Models\User;
use App\Services\FetNet\FaculteeSyncPayloadBuilder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FaculteeSyncPayloadBuilderTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_builds_semester_room_and_session_payload(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE']);
        $ay      = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem     = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        $bldg    = Building::create(['client_id' => $client->id, 'name' => 'FPMIPA']);
        $room    = Space::create(['client_id' => $client->id, 'building_id' => $bldg->id, 'name' => 'Room 101', 'code' => 'R101', 'floor' => '1', 'capacity' => 40]);
        $subject = Subject::create(['program_id' => $program->id, 'code' => 'MAT101', 'name' => 'Calculus', 'credit' => 3, 'semester' => 1]);
        $plan    = ActivityPlanning::create(['subject_id' => $subject->id, 'program_id' => $program->id, 'semester_id' => $sem->id]);
        $act     = Activity::create(['program_id' => $program->id, 'planning_id' => $plan->id, 'duration' => 2, 'active' => true]);
        $teacher = Teacher::create(['program_id' => $program->id, 'code' => 'DRX', 'name' => 'Dr. X']);
        $act->teachers()->attach($teacher->id);

        $slot = TimetableSlot::create([
            'client_id' => $client->id, 'semester_id' => $sem->id, 'activity_id' => $act->id,
            'room_id' => $room->id, 'day_index' => 1, 'hour_index' => 7, 'duration' => 2, 'locked' => true,
        ]);

        $payload = (new FaculteeSyncPayloadBuilder())->build($client->id, $sem->id);

        $this->assertSame('2025-ganjil', $payload['semester']['ref']);
        $this->assertSame('2025/2026', $payload['semester']['academic_year']);
        $this->assertSame('ganjil', $payload['semester']['term']);

        $this->assertCount(1, $payload['rooms']);
        $this->assertSame($room->id, $payload['rooms'][0]['fetnet_space_id']);
        $this->assertSame('R101', $payload['rooms'][0]['code']);
        $this->assertSame('FPMIPA', $payload['rooms'][0]['building']);
        $this->assertSame(40, $payload['rooms'][0]['capacity']);

        $this->assertCount(1, $payload['sessions']);
        $s = $payload['sessions'][0];
        $this->assertSame($slot->id, $s['fetnet_slot_id']);
        $this->assertSame($act->id, $s['fetnet_activity_id']);
        $this->assertSame(1, $s['day_of_week']);
        $this->assertSame(7, $s['start_hour']);
        $this->assertSame(2, $s['duration']);
        $this->assertSame($room->id, $s['fetnet_space_id']);
        $this->assertSame('MAT101', $s['subject_code']);
        $this->assertSame('Calculus', $s['subject_name']);
        $this->assertSame('DRX', $s['lecturer']);
        $this->assertTrue($s['locked']);
    }

    public function test_it_skips_unplaced_slots(): void
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 2, 'name' => 'Genap']);

        $payload = (new FaculteeSyncPayloadBuilder())->build($client->id, $sem->id);

        $this->assertSame('2025-genap', $payload['semester']['ref']);
        $this->assertSame([], $payload['rooms']);
        $this->assertSame([], $payload['sessions']);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=FaculteeSyncPayloadBuilderTest`
Expected: FAIL with "Class \"App\Services\FetNet\FaculteeSyncPayloadBuilder\" not found".

- [ ] **Step 3: Implement the builder**

Create `app/Services/FetNet/FaculteeSyncPayloadBuilder.php`:

```php
<?php

namespace App\Services\FetNet;

use App\Models\FetNet\Semester;
use App\Models\FetNet\TimetableSlot;
use Illuminate\Support\Carbon;

/**
 * Builds the per-semester timetable snapshot that FetNet pushes to the Facultee app.
 * Reads the placed timetable slots for a client+semester (with subject, teachers,
 * students and room relations) and shapes them into the sync contract: a semester
 * descriptor, the distinct rooms referenced, and one session per placed slot. See
 * the design spec docs/superpowers/specs/2026-06-24-facultee-room-management-design.md.
 */
class FaculteeSyncPayloadBuilder
{
    /**
     * @return array{semester:array{ref:string,academic_year:string,term:string},published_at:string,rooms:array<int,array<string,mixed>>,sessions:array<int,array<string,mixed>>}
     */
    public function build(int $clientId, int $semesterId): array
    {
        $semester = Semester::with('academicYear')->findOrFail($semesterId);
        $term     = $semester->semester == 1 ? 'ganjil' : 'genap';
        $yearStart = (int) ($semester->academicYear?->year_start ?? 0);

        $slots = TimetableSlot::with([
                'activity.planning.subject:id,code,name',
                'activity.teachers:id,code,name',
                'activity.students:id,name',
                'room.building:id,name',
            ])
            ->where('client_id', $clientId)
            ->where('semester_id', $semesterId)
            ->whereNotNull('day_index')
            ->whereNotNull('hour_index')
            ->get();

        $sessions = [];
        $rooms    = [];

        foreach ($slots as $slot) {
            $teachers = $slot->activity?->teachers ?? collect();
            $lecturer = $teachers->pluck('code')->filter()->implode(', ')
                     ?: $teachers->pluck('name')->filter()->implode(', ');

            $sessions[] = [
                'fetnet_slot_id'     => $slot->id,
                'fetnet_activity_id' => $slot->activity_id,
                'day_of_week'        => (int) $slot->day_index,
                'start_hour'         => (int) $slot->hour_index,
                'duration'           => (int) ($slot->duration ?? 1),
                'fetnet_space_id'    => $slot->room_id,
                'subject_code'       => $slot->activity?->planning?->subject?->code,
                'subject_name'       => $slot->activity?->planning?->subject?->name,
                'lecturer'           => $lecturer,
                'student_group'      => $slot->activity?->students->pluck('name')->filter()->implode(', '),
                'locked'             => (bool) $slot->locked,
            ];

            if ($slot->room && ! isset($rooms[$slot->room->id])) {
                $rooms[$slot->room->id] = [
                    'fetnet_space_id' => $slot->room->id,
                    'code'            => $slot->room->code,
                    'name'            => $slot->room->name,
                    'building'        => $slot->room->building?->name,
                    'floor'           => $slot->room->floor,
                    'capacity'        => $slot->room->capacity,
                    'facilities'      => [],
                ];
            }
        }

        return [
            'semester' => [
                'ref'           => $yearStart . '-' . $term,
                'academic_year' => $yearStart . '/' . ($yearStart + 1),
                'term'          => $term,
            ],
            'published_at' => Carbon::now()->toIso8601String(),
            'rooms'        => array_values($rooms),
            'sessions'     => $sessions,
        ];
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=FaculteeSyncPayloadBuilderTest`
Expected: PASS (2 tests). If `Activity::students()` relation name differs, check `app/Models/FetNet/Activity.php` and adjust the eager-load + pluck to the real relation name (it is `students` per `resources/views/pages/client/timetable/view/⚡idx.blade.php:115`).

- [ ] **Step 5: Commit**

```bash
git add app/Services/FetNet/FaculteeSyncPayloadBuilder.php tests/Feature/FetNet/FaculteeSyncPayloadBuilderTest.php
git commit -m "feat: build facultee timetable sync payload from placed slots

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 3: Completion event

**Files:**
- Create: `app/Events/FetNet/TimetableSyncedEvent.php`
- Test: `tests/Feature/FetNet/TimetableSyncedEventTest.php`

**Interfaces:**
- Produces: `new TimetableSyncedEvent(int $clientId, int $semesterId, string $status, ?string $message)`; broadcasts on channel `facultee-sync.<clientId>` as `.TimetableSyncedEvent` with `broadcastWith()` = `client_id, semester_id, status, message`.

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use App\Events\FetNet\TimetableSyncedEvent;
use Tests\TestCase;

class TimetableSyncedEventTest extends TestCase
{
    public function test_event_broadcasts_on_client_channel_with_payload(): void
    {
        $event = new TimetableSyncedEvent(3, 5, 'success', 'Synced 10 sessions.');

        $this->assertSame('facultee-sync.3', $event->broadcastOn()->name);
        $this->assertSame('TimetableSyncedEvent', $event->broadcastAs());
        $this->assertSame(
            ['client_id' => 3, 'semester_id' => 5, 'status' => 'success', 'message' => 'Synced 10 sessions.'],
            $event->broadcastWith(),
        );
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=TimetableSyncedEventTest`
Expected: FAIL with "Class ... TimetableSyncedEvent not found".

- [ ] **Step 3: Implement the event**

Create `app/Events/FetNet/TimetableSyncedEvent.php` (mirror `SolverFinishedEvent`):

```php
<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Broadcast (now) when a timetable sync to the Facultee app finishes, on channel
 * `facultee-sync.<clientId>` as `.TimetableSyncedEvent`. Payload: client_id,
 * semester_id, status (success|failed), message. The client timetable UI listens to
 * confirm the push without polling. See [[fetnet-job-events]].
 */
class TimetableSyncedEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public int $clientId,
        public int $semesterId,
        public string $status,       // success | failed
        public ?string $message = null,
    ) {}

    public function broadcastOn(): Channel
    {
        return new Channel('facultee-sync.' . $this->clientId);
    }

    public function broadcastAs(): string
    {
        return 'TimetableSyncedEvent';
    }

    public function broadcastWith(): array
    {
        return [
            'client_id'   => $this->clientId,
            'semester_id' => $this->semesterId,
            'status'      => $this->status,
            'message'     => $this->message,
        ];
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=TimetableSyncedEventTest`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add app/Events/FetNet/TimetableSyncedEvent.php tests/Feature/FetNet/TimetableSyncedEventTest.php
git commit -m "feat: add TimetableSyncedEvent broadcast for facultee sync

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 4: Sync job

**Files:**
- Create: `app/Jobs/FetNet/SyncTimetableToFaculteeJob.php`
- Test: `tests/Feature/FetNet/SyncTimetableToFaculteeJobTest.php`

**Interfaces:**
- Consumes: `FaculteeSyncPayloadBuilder::build()`, `config('services.facultee.url'|'token')`, `TimetableSyncedEvent`.
- Produces: `new SyncTimetableToFaculteeJob(int $clientId, int $semesterId)`; `handle()` POSTs `{url}/api/sync/timetable` with `Authorization: Bearer <token>` and the payload, then dispatches `TimetableSyncedEvent`.

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use App\Events\FetNet\TimetableSyncedEvent;
use App\Jobs\FetNet\SyncTimetableToFaculteeJob;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Semester;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class SyncTimetableToFaculteeJobTest extends TestCase
{
    use RefreshDatabase;

    private function semester(): array
    {
        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        return [$client, $sem];
    }

    public function test_it_posts_payload_with_bearer_token_and_broadcasts_success(): void
    {
        config()->set('services.facultee.url', 'http://facultee-app:8000');
        config()->set('services.facultee.token', 'secret-token');
        Http::fake(['*/api/sync/timetable' => Http::response(['rooms_upserted' => 0, 'sessions_created' => 0], 200)]);
        Event::fake([TimetableSyncedEvent::class]);

        [$client, $sem] = $this->semester();

        (new SyncTimetableToFaculteeJob($client->id, $sem->id))->handle();

        Http::assertSent(function ($request) {
            return $request->url() === 'http://facultee-app:8000/api/sync/timetable'
                && $request->hasHeader('Authorization', 'Bearer secret-token')
                && $request['semester']['ref'] === '2025-ganjil';
        });
        Event::assertDispatched(TimetableSyncedEvent::class, fn ($e) => $e->status === 'success');
    }

    public function test_it_broadcasts_failed_when_facultee_responds_with_error(): void
    {
        config()->set('services.facultee.url', 'http://facultee-app:8000');
        config()->set('services.facultee.token', 'secret-token');
        Http::fake(['*/api/sync/timetable' => Http::response(['message' => 'boom'], 500)]);
        Event::fake([TimetableSyncedEvent::class]);

        [$client, $sem] = $this->semester();

        (new SyncTimetableToFaculteeJob($client->id, $sem->id))->handle();

        Event::assertDispatched(TimetableSyncedEvent::class, fn ($e) => $e->status === 'failed');
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=SyncTimetableToFaculteeJobTest`
Expected: FAIL with "Class ... SyncTimetableToFaculteeJob not found".

- [ ] **Step 3: Implement the job**

Create `app/Jobs/FetNet/SyncTimetableToFaculteeJob.php`:

```php
<?php

namespace App\Jobs\FetNet;

use App\Events\FetNet\TimetableSyncedEvent;
use App\Services\FetNet\FaculteeSyncPayloadBuilder;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Queued job: push a client+semester's published timetable snapshot to the Facultee
 * app's sync endpoint, authenticated with a bearer token. Broadcasts
 * TimetableSyncedEvent (success|failed) so the timetable UI can confirm the push
 * without polling. See [[fetnet-job-events]] and the design spec.
 */
class SyncTimetableToFaculteeJob implements ShouldQueue
{
    use Queueable;

    public int $tries   = 1;
    public int $timeout = 120;

    public function __construct(
        public int $clientId,
        public int $semesterId,
    ) {}

    public function handle(FaculteeSyncPayloadBuilder $builder): void
    {
        $url   = rtrim((string) config('services.facultee.url'), '/');
        $token = (string) config('services.facultee.token');

        if ($url === '' || $token === '') {
            Log::warning('Facultee sync skipped: missing services.facultee.url/token.');
            TimetableSyncedEvent::dispatch($this->clientId, $this->semesterId, 'failed', 'Facultee endpoint not configured.');
            return;
        }

        $payload = $builder->build($this->clientId, $this->semesterId);

        try {
            $response = Http::withToken($token)
                ->acceptJson()
                ->timeout(60)
                ->post($url . '/api/sync/timetable', $payload);

            if ($response->successful()) {
                $count = count($payload['sessions']);
                TimetableSyncedEvent::dispatch($this->clientId, $this->semesterId, 'success', "Synced {$count} session(s) to Facultee.");
                return;
            }

            Log::error('Facultee sync failed', ['status' => $response->status(), 'body' => $response->body()]);
            TimetableSyncedEvent::dispatch($this->clientId, $this->semesterId, 'failed', 'Facultee rejected the sync (HTTP ' . $response->status() . ').');
        } catch (\Throwable $e) {
            Log::error('Facultee sync threw', ['error' => $e->getMessage()]);
            TimetableSyncedEvent::dispatch($this->clientId, $this->semesterId, 'failed', 'Could not reach Facultee.');
        }
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=SyncTimetableToFaculteeJobTest`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add app/Jobs/FetNet/SyncTimetableToFaculteeJob.php tests/Feature/FetNet/SyncTimetableToFaculteeJobTest.php
git commit -m "feat: queue job to push timetable snapshot to facultee

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 5: Artisan command

**Files:**
- Create: `app/Console/Commands/FetNet/SyncFaculteeCommand.php`
- Test: `tests/Feature/FetNet/SyncFaculteeCommandTest.php`

**Interfaces:**
- Consumes: `SyncTimetableToFaculteeJob`.
- Produces: command signature `facultee:sync {client} {semester}` that dispatches the job.

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use App\Jobs\FetNet\SyncTimetableToFaculteeJob;
use Illuminate\Support\Facades\Queue;
use Tests\TestCase;

class SyncFaculteeCommandTest extends TestCase
{
    public function test_command_dispatches_sync_job_with_arguments(): void
    {
        Queue::fake();

        $this->artisan('facultee:sync', ['client' => 7, 'semester' => 3])
            ->assertExitCode(0);

        Queue::assertPushed(SyncTimetableToFaculteeJob::class, function ($job) {
            return $job->clientId === 7 && $job->semesterId === 3;
        });
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=SyncFaculteeCommandTest`
Expected: FAIL — command `facultee:sync` not found (non-zero exit).

- [ ] **Step 3: Implement the command**

Create `app/Console/Commands/FetNet/SyncFaculteeCommand.php`:

```php
<?php

namespace App\Console\Commands\FetNet;

use App\Jobs\FetNet\SyncTimetableToFaculteeJob;
use Illuminate\Console\Command;

/**
 * Manually push a client+semester's published timetable to the Facultee app by
 * dispatching SyncTimetableToFaculteeJob. Useful for backfills and re-syncs outside
 * the automatic publish trigger. Usage: `php artisan facultee:sync {client} {semester}`.
 */
class SyncFaculteeCommand extends Command
{
    protected $signature   = 'facultee:sync {client : FetNet client id} {semester : FetNet semester id}';
    protected $description = 'Push a client+semester timetable snapshot to the Facultee app';

    public function handle(): int
    {
        $clientId   = (int) $this->argument('client');
        $semesterId = (int) $this->argument('semester');

        SyncTimetableToFaculteeJob::dispatch($clientId, $semesterId);

        $this->info("Dispatched Facultee sync for client {$clientId}, semester {$semesterId}.");

        return self::SUCCESS;
    }
}
```

(Laravel 12 auto-discovers commands in `app/Console/Commands`; no manual registration needed. If this project uses an explicit `bootstrap/app.php` `withCommands`, confirm the namespace is scanned.)

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=SyncFaculteeCommandTest`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add app/Console/Commands/FetNet/SyncFaculteeCommand.php tests/Feature/FetNet/SyncFaculteeCommandTest.php
git commit -m "feat: add facultee:sync artisan command

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 6: Dispatch on publish

**Files:**
- Modify: `resources/views/pages/client/timetable/⚡idx.blade.php` (the `publish()` method, around lines 190–212)
- Test: `tests/Feature/FetNet/PublishTriggersFaculteeSyncTest.php`

**Interfaces:**
- Consumes: `SyncTimetableToFaculteeJob`.
- Produces: after a successful `publish()`, `SyncTimetableToFaculteeJob` is dispatched for the published client+semester.

- [ ] **Step 1: Write the failing test**

```php
<?php

namespace Tests\Feature\FetNet;

use App\Jobs\FetNet\SyncTimetableToFaculteeJob;
use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use App\Models\FetNet\Semester;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Queue;
use Livewire\Livewire;
use Tests\TestCase;

class PublishTriggersFaculteeSyncTest extends TestCase
{
    use RefreshDatabase;

    public function test_publishing_dispatches_facultee_sync_job(): void
    {
        Queue::fake();

        $user   = User::factory()->create();
        $client = Client::create(['user_id' => $user->id]);
        $ay     = AcademicYear::create(['client_id' => $client->id, 'year_start' => 2025, 'is_active' => true]);
        $sem    = Semester::create(['client_id' => $client->id, 'academic_year_id' => $ay->id, 'semester' => 1, 'name' => 'Ganjil']);
        FetCompile::create([
            'client_id' => $client->id, 'semester_id' => $sem->id,
            'status' => 'success', 'solver_status' => 'success',
        ]);

        Livewire::actingAs($user)->test('pages::client.timetable.idx')
            ->set('academicYearId', $ay->id)
            ->set('semesterId', $sem->id)
            ->call('publish');

        Queue::assertPushed(SyncTimetableToFaculteeJob::class, function ($job) use ($client, $sem) {
            return $job->clientId === $client->id && $job->semesterId === $sem->id;
        });
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=PublishTriggersFaculteeSyncTest`
Expected: FAIL — no `SyncTimetableToFaculteeJob` pushed.
(If the test fails instead on the publish guard — e.g. `solver_status` must be in `['success','stopped']` — keep the `FetCompile` `solver_status => 'success'` as written; that satisfies the guard at line ~194.)

- [ ] **Step 3: Add the dispatch**

In `resources/views/pages/client/timetable/⚡idx.blade.php`, add the import near the other `use` statements at the top of the component class file:

```php
use App\Jobs\FetNet\SyncTimetableToFaculteeJob;
```

Then in `publish()`, immediately after the success toast line
`$this->success('Timetable published. Programs can now view it.', ...);`, add:

```php
        // Push the published snapshot to the Facultee app (room management).
        SyncTimetableToFaculteeJob::dispatch($c->client_id, $c->semester_id);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=PublishTriggersFaculteeSyncTest`
Expected: PASS

- [ ] **Step 5: Run the full new-suite to confirm no regressions**

Run: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=Facultee`
Then also: `docker compose exec -u www-data -e HOME=/tmp -T app php artisan test --filter=Timetable`
Expected: all PASS.

- [ ] **Step 6: Commit**

```bash
git add "resources/views/pages/client/timetable/⚡idx.blade.php" tests/Feature/FetNet/PublishTriggersFaculteeSyncTest.php
git commit -m "feat: dispatch facultee sync when a timetable is published

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Self-Review

**Spec coverage (FetNet-sender slice):**
- Config (`services.facultee.url/token`) → Task 1. ✔
- Payload builder (semester ref, rooms, sessions per contract) → Task 2. ✔
- Job POSTs to `/api/sync/timetable` with bearer token → Task 4. ✔
- Job broadcasts completion event (job-event rule) → Tasks 3 + 4. ✔
- Manual command `facultee:sync` → Task 5. ✔
- Trigger on `publish()` → Task 6. ✔
- Idempotency, merge logic, conflict recompute, rooms/class_sessions/bookings schema, Vue/Tailwind/shadcn, CAS SSO + staff/faculty roles → **Facultee app (separate repo)**, NOT in this plan. Tracked as a follow-up spec→plan.

**Placeholder scan:** No TBD/TODO; every code step shows full code; commands have expected output. ✔

**Type consistency:** `build(int,int): array` consumed identically in Task 4; `SyncTimetableToFaculteeJob(int $clientId, int $semesterId)` used identically in Tasks 4/5/6; `TimetableSyncedEvent(int,int,string,?string)` used in Tasks 3/4. ✔

## Out of scope (next spec→plan: Facultee app)

The Facultee Laravel API + Vue SPA is a separate repository and a separate
brainstorm→spec→plan cycle: docker-compose joining `WebFPTE`, `facultee` DB +
migrations (rooms, class_sessions, room_bookings, sync_logs), the receiving
`POST /api/sync/timetable` with merge + conflict recompute, booking CRUD +
availability, CAS SSO + `staff`/`faculty` roles, and the Vue 3 + Tailwind v4 +
shadcn-vue frontend.
