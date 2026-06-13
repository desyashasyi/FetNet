# Delete All Subjects — Design

**Date:** 2026-06-13
**Page:** Program → Data → Subjects (`/program/data/subjects`)
**File:** `resources/views/pages/program/data/subjects/⚡idx.blade.php`

## Goal

Let a program user delete all subjects of their program in one action, behind a
confirmation dialog.

## Decisions

| Topic | Decision |
|-------|----------|
| **Scope** | All subjects of the current program — ignores active year/search filter. |
| **Confirmation** | Dedicated `x-modal` (separate from single-delete modal) with subject count + warning. Cancel / Delete All (red). |
| **Cascade** | Iterate Eloquent models (chunked) and call `delete()` per model so the `deleting` hook cascades to related activities. Bulk `->delete()` would skip the cascade. |
| **Button visibility** | Shown only when the program has ≥1 subject. |
| **Feedback** | Toast "N subjects deleted. Related activities also deleted." Then refresh list + options, reset pagination. |

## Implementation

In `⚡idx.blade.php`:
- Add `public bool $delAllModal = false;`.
- Add a computed/helper `subjectCount()` = count of program subjects (for button visibility + dialog text).
- Add `confirmDeleteAll()` → opens `$delAllModal`.
- Add `deleteAll()`:
  ```php
  $program = $this->program();
  if (! $program) { $this->delAllModal = false; return; }
  $count = 0;
  Subject::where('program_id', $program->id)
      ->chunkById(200, function ($subjects) use (&$count) {
          foreach ($subjects as $s) { $s->delete(); $count++; }
      });
  $this->delAllModal = false;
  $this->resetPage();
  $this->dispatch('subject-changed');
  $this->dispatch('refresh-subject-options');
  $this->warning("{$count} subjects deleted. Related activities also deleted.", position: 'toast-top toast-center');
  ```
- Header toolbar: add `Delete All` button (`btn-ghost btn-sm text-error`, `o-trash`) wrapped in `@if($subjectCount > 0)`, `wire:click="confirmDeleteAll"`.
- Add the confirmation `x-modal` (mirrors existing single-delete `delModal`).

## Out of Scope (YAGNI)

- Delete filtered-only subset.
- Undo / restore.

## Testing

Feature test (sqlite + RefreshDatabase, program-scoped):
- Program with N subjects + related activities → `deleteAll` soft-deletes all N subjects and their activities; subjects of a *different* program are untouched.
- Use `Livewire::test` (Volt) on the page acting as the program user, call `confirmDeleteAll` then `deleteAll`, assert counts.
