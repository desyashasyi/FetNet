# Facultee — Room Management Backend + Timetable Sync

**Date:** 2026-06-24
**Status:** Approved design, pending implementation plan

## Summary

Build **Facultee**, a separate room-management application served at
`facultee.techupi.id`. FetNet remains the authority for room data and the class
timetable. When a client publishes a timetable in FetNet, FetNet **pushes** a
per-semester snapshot to Facultee over HTTP. Facultee owns the operational layer
for the rest of the semester: room bookings (peminjaman), availability views, and
conflict tracking. Re-publishing from FetNet **merges** (idempotent upsert), it
does not blindly overwrite, and it never deletes Facultee-owned bookings.

## Goals

- Facultee is an independent Laravel API + Vue SPA, separate repo, separate
  database, deployed in the same Docker host/network as FetNet.
- One-way timetable sync FetNet → Facultee, triggered on publish, idempotent and
  merge-based.
- Facultee manages room bookings and surfaces availability (class sessions +
  bookings), flagging conflicts when a re-published class session overlaps an
  existing booking.
- Shared identity with FetNet (CAS SSO); Facultee adds `staff` and `faculty`
  roles on top of FetNet's existing role set.

## Non-Goals

- No two-way sync. Facultee never writes timetable changes back to FetNet.
- No room master editing in Facultee — rooms are owned by FetNet and arrive via
  sync (read-only copy locally).
- No automatic cancellation of bookings on conflict (flag only).
- Vue UI implementation detail beyond stack choice and the API contract is out of
  scope for this spec (covered by the plan).

## Architecture

Separate repo. Separate `docker-compose.yml` that joins the **existing**
`WebFPTE` network (declared `external: true` in Facultee's compose) so FetNet's
`app` container can reach Facultee internally by service name.

```
network WebFPTE (external, shared)
├── fetnet-app        (existing)            -> db `fetnet`
├── facultee-app      (laravel php-fpm)     -> db `facultee`
├── facultee-worker   (queue:work, optional)
├── mariadb           (existing, SHARED instance; new db `facultee` + user)
├── redis             (existing, shared; Facultee uses its own prefix / db index)
└── edge nginx        (host routing: fetnet.techupi.id -> fetnet,
                                     facultee.techupi.id -> facultee)
```

- **Database:** same MariaDB instance, **separate database** `facultee` with its
  own user. No cross-database connection — Facultee uses only its own schema. The
  boundary is the HTTP sync API, not shared tables.
- **Redis:** shared instance, separate key prefix / DB index for cache + queue.
- **Edge nginx:** two `server` blocks keyed by `server_name`. FetNet keeps its
  block; add a `facultee.techupi.id` block fronting `facultee-app`. TLS and exact
  mount layout finalized in the plan.
- **Internal call:** FetNet → `http://facultee-app:8000/api/sync/timetable`.

### Frontend stack (Facultee SPA)

- **Vue 3 + Vite + TypeScript**
- **Tailwind v4 + shadcn-vue** (reka-ui / Radix Vue under the hood; components are
  copied into the repo, not a dependency lib, so they're owned and editable)
- **Pinia** for state, native `fetch` (TanStack Query optional later)
- **Auth:** Sanctum SPA cookie session established after CAS SSO
- Built static assets served by the Facultee nginx block; the SPA talks to the
  Facultee API.
- Relevant components: `Table`, `Dialog`, `Calendar`/date-picker (bookings),
  `Badge` (conflict status), `Select`, `Card`, `Sonner` (toast).

This differs from FetNet's MaryUI/daisyUI Blade stack, which is fine — Facultee is
a separate SPA.

## Data model (Facultee database)

Semester is represented as a **string ref** (e.g. `"2025-ganjil"`) sent by FetNet,
not a local semester table. All synced rows are scoped by this ref.

- **`rooms`** — local read-only copy, owned by FetNet, populated via sync.
  - `fetnet_space_id` (unique), `code`, `name`, `building`, `floor`,
    `capacity`, `facilities` (json), `is_active`, timestamps.
- **`class_sessions`** — published timetable snapshot (the weekly class grid).
  - `fetnet_slot_id` (unique), `fetnet_activity_id`, `semester_ref`,
    `day_of_week` (1–7), `start_hour` (int), `duration` (hours), `room_id` (FK
    rooms), `subject_code`, `subject_name`, `lecturer`, `student_group`,
    `locked` (bool), `last_synced_at`, timestamps.
  - Weekly recurring (matches FetNet's weekly-only model).
- **`room_bookings`** — Facultee-owned (peminjaman), **specific-date** events.
  - `room_id` (FK rooms), `title`, `borrower`, `purpose`, `start_at`
    (datetime), `end_at` (datetime), `status`
    (`pending|approved|cancelled|conflict`), `created_by` (user),
    `conflict_session_id` (nullable FK class_sessions), timestamps.
- **`sync_logs`** — one row per received sync batch.
  - `semester_ref`, `received_at`, `rooms_upserted`, `sessions_created`,
    `sessions_updated`, `sessions_removed`, `conflicts_count`, `source`.

**Availability** is derived, not stored: a room is busy at a given weekly
day/hour if a `class_session` covers it, and busy at a specific datetime if an
`approved` `room_booking` covers it.

## Sync API contract

`POST /api/sync/timetable` — bearer token auth (machine-to-machine).

Request (one semester per call):
```json
{
  "semester": { "ref": "2025-ganjil", "academic_year": "2025/2026", "term": "ganjil" },
  "published_at": "2026-06-24T10:00:00Z",
  "rooms": [
    { "fetnet_space_id": 1, "code": "R101", "name": "Ruang 101",
      "building": "FPMIPA", "floor": "1", "capacity": 40, "facilities": [] }
  ],
  "sessions": [
    { "fetnet_slot_id": 12, "fetnet_activity_id": 7, "day_of_week": 1,
      "start_hour": 7, "duration": 2, "fetnet_space_id": 1,
      "subject_code": "MAT101", "subject_name": "Kalkulus",
      "lecturer": "Dr. X", "student_group": "PTE-2023", "locked": true }
  ]
}
```

Response:
```json
{ "rooms_upserted": 30, "sessions_created": 5, "sessions_updated": 12,
  "sessions_removed": 2, "conflicts": [41, 88] }
```

The contract is idempotent: re-sending the same payload yields the same Facultee
state (zero created/updated/removed on a no-op).

## Merge logic (the heart of "sinkronisasi")

Scoped to the payload's `semester.ref`, in one DB transaction:

1. **Rooms:** upsert by `fetnet_space_id`. (Rooms are never deleted by sync; a
   room missing from a payload stays — it may host bookings.)
2. **Sessions:** reconcile by `fetnet_slot_id` within this `semester_ref`:
   - present in payload, not in DB → **create**
   - present in both, fields differ → **update**
   - in DB for this semester, absent from payload → **remove** (class was
     un-plotted). Other semesters are untouched.
3. **Conflict recompute:** after the session upsert, for this semester, find any
   `approved`/`pending` booking whose `room_id` + datetime maps onto a weekly
   `class_session` (same room, the booking's weekday/hour-range overlaps the
   session's `day_of_week` + `start_hour..start_hour+duration`). Mark such
   bookings `status = conflict` and set `conflict_session_id`. Bookings currently
   flagged `conflict` that no longer overlap any session revert to `approved` and
   clear `conflict_session_id`; `cancelled` bookings are left untouched.
   **Bookings are never auto-deleted.**

## FetNet side (sender)

- **Config:** `config/services.php` → `facultee.url`, `facultee.token` (env).
- **Payload builder:** a service that, given a `client_id` + `semester_id`,
  builds the rooms + sessions arrays from `TimetableSlot` + `Space` (subject
  name, lecturer, student group resolved via existing relations).
- **Job:** `SyncTimetableToFaculteeJob` — POSTs the payload, records the
  response, and **broadcasts a completion event** (per FetNet's job-event rule)
  so the timetable UI can confirm the sync.
- **Trigger:** dispatch the job from the existing `publish()` in
  `resources/views/pages/client/timetable/⚡idx.blade.php`. Publishing already
  marks the FetNet-side authority; sync rides on that action.
- **Command:** `php artisan facultee:sync {client} {semester}` for manual
  re-sync / backfill.

## Auth & security

- **Users:** shared identity via **CAS SSO** (same as FetNet). One user source.
- **Roles:** superset of FetNet roles (admin, client, program, …) **plus**
  `staff` and `faculty`. Booking management is gated to `staff`/`faculty`/admin;
  read/availability open to authenticated users (exact matrix in the plan).
- **SPA session:** Sanctum cookie issued after CAS, consumed by the Vue app.
- **Sync endpoint:** bearer token (shared secret, env), not a user session;
  reachable over the internal Docker network. Rate/replay protection is a plan
  detail.

## Testing

- **FetNet:** payload builder produces the correct shape from slots; job POSTs
  with auth header (HTTP fake); `facultee:sync` command dispatches/builds
  correctly.
- **Facultee:** sync endpoint upsert (create/update/remove) per semester scope;
  idempotency (re-POST is a no-op); conflict detection marks/unmarks bookings;
  bookings never deleted; auth rejects missing/wrong token; role gates on booking
  endpoints.
- Vue: API contract is the boundary; component tests out of scope here.

## Open items for the plan

- Edge nginx exact vhost + TLS + document-root mount for Facultee.
- CAS SSO integration specifics in Facultee (reuse FetNet's CAS client config).
- Role → permission matrix for booking actions.
- Whether `facultee-worker` is needed at launch (sync is synchronous on receive;
  FetNet side is the queued part).
