---
name: fetnet-job-events
description: Use when writing any queued job in FetNet. Every job MUST broadcast a completion event so the frontend Livewire component can react without polling.
---

# FetNet: Job → Broadcast Event Pattern

## Rule

**Every queued job in `app/Jobs/FetNet/` MUST dispatch a broadcast event at the end of `handle()`.**
The corresponding Livewire component MUST listen via `getListeners()` and refresh its data.

## 1. Event (in `app/Events/FetNet/`)

```php
<?php

namespace App\Events\FetNet;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SomethingDoneEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public string $status,   // 'success' | 'error'
        public string $message,
        // add other payload fields as needed (e.g. public int $activityId)
    ) {}

    public function broadcastOn(): array
    {
        return [new Channel('channel-name')];
    }

    public function broadcastAs(): string
    {
        return 'SomethingDoneEvent';
    }
}
```

Rules:
- Use `ShouldBroadcastNow` (not `ShouldBroadcast`) — fires immediately, not via queue
- Channel name: lowercase, kebab-case, descriptive (e.g. `activity-spaces`, `space-import`)
- Always include `status` + `message` fields minimum
- **Payload keys are camelCase** in the received PHP array (JSON-decoded as-is). e.g. `public int $activityId` → `$event['activityId']`

## 2. Job (in `app/Jobs/FetNet/`)

```php
public function handle(): void
{
    try {
        // ... do the work ...
        SomethingDoneEvent::dispatch('success', 'Work done.');
    } catch (\Throwable $e) {
        SomethingDoneEvent::dispatch('error', 'Failed: ' . $e->getMessage());
        throw $e;
    }
}
```

## 3. Livewire Component Listener

```php
public function getListeners(): array
{
    return ['echo:channel-name,.SomethingDoneEvent' => 'onSomethingDone'];
}

public function onSomethingDone(array $event): void
{
    // 1. Increment a key property to force table re-render via wire:key
    $this->someKey++;

    // 2. Refresh modal state if modal is open and relates to this event
    $eventId = $event['someId'] ?? null;   // camelCase from broadcast payload
    if ($this->modal && $this->currentId === $eventId) {
        // re-query local state from DB
        $this->someIds = SomeModel::find($this->currentId)
            ?->relation()->pluck('table.id')->toArray() ?? [];
        $this->page = 1;
    }

    // 3. Show toast
    ($event['status'] ?? '') === 'success'
        ? $this->success($event['message'], position: 'toast-top toast-center')
        : $this->error($event['message'],   position: 'toast-top toast-center');
}
```

Key points:
- `echo:channel-name,.EventName` — dot prefix on event name is required
- Incrementing a `$key` property triggers Livewire re-render → `with()` re-runs → fresh DB queries
- Always check `$this->modal` before re-querying modal state to avoid unnecessary queries
- Payload keys are camelCase: `$event['activityId']`, not `$event['activity_id']`
- Use `$event['key'] ?? $event['snake_key'] ?? null` for safety if unsure

## 4. wire:key Pattern for Forced Table Re-render

In the blade, the table card must have a `wire:key` that changes when data updates:

```blade
<x-card wire:key="table-{{ $someKey }}">
    <x-table :rows="$rows" ... />
</x-card>
```

The `$someKey` is incremented in the echo handler. Combined with `withCount()` (not `with()->count()`), this ensures:
- `withCount()` → count in Eloquent `$attributes` → included in serialization → MaryUI `$uuid` changes → row `wire:key` changes → morphdom recreates rows
- `wire:key` on card → card replaced entirely when key changes → guaranteed DOM update

**Never use `with(['relation'])->count()` for display counts. Use `->withCount('relation')`** — dynamic PHP properties are NOT serialized by Eloquent, so MaryUI's `$uuid` won't change, morphdom won't update rows.

## Existing Examples

| Job | Event | Channel |
|-----|-------|---------|
| `AssignSpacesToActivityJob` | `ActivitySpacesUpdatedEvent` | `activity-spaces` |
| `RemoveAllSpacesFromActivityJob` | `ActivitySpacesUpdatedEvent` | `activity-spaces` |
| `SpaceImportJob` | `SpaceImportEvent` | `space-import` |
| `TeachersImportJob` | `TeachersImportEvent` | `scheduleImport` |
| `SubjectsImportJob` | `SubjectsImportEvent` | *(check event file)* |

## Checklist When Writing a New Job

- [ ] Job dispatches event at end of `handle()` (wrap in try/catch for error status)
- [ ] Event uses `ShouldBroadcastNow`
- [ ] Event has `status` + `message` fields
- [ ] Channel registered in `routes/channels.php` if private
- [ ] Livewire component has `getListeners()` → `echo:channel,.EventName`
- [ ] Handler increments a `$key` property to trigger re-render
- [ ] Handler refreshes modal state if applicable (check `$this->modal` first)
- [ ] Handler shows toast from `$event['status']` / `$event['message']`
- [ ] Table card uses `wire:key="table-{{ $key }}"` in blade
- [ ] Table query uses `withCount()` not `with()->count()`
