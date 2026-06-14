# Hierarchical Labels in Activity Student-Group Picker — Design

**Date:** 2026-06-14
**Page:** Program → Data → Activities → activity edit sheet
**File:** `resources/views/pages/program/data/activities/activity-edit-sheet.blade.php` (`searchStudents()` only)

## Problem

The "Student Groups" `x-choices` picker already lists both groups and sub-groups
(any student with a `parent_id`), but each option label is the bare `$s->name`
("TE01-1", "A"), so a group can't be told apart from a sub-group, nor which batch
it belongs to.

## Hierarchy (verified)

`fetnet_student` is self-referential via `parent_id`, three levels:
- batch (parent_id null, e.g. "2026")
- group (parent = batch, e.g. "TE01-1")
- sub-group (parent = group, e.g. "A")

## Change

In `searchStudents()`:
- Keep the candidate set: `program_id = current program`, `whereNotNull('parent_id')`
  (groups + sub-groups; batches excluded), filter `name like %value%`
  OR `id in $this->studentIds` (keep already-selected resolvable).
- `with(['parent.parent'])` to cover all 3 levels without N+1.
- Map each student to `['id' => $s->id, 'name' => <path>]` where `<path>` is the
  ancestor chain joined by ` / ` (root → leaf):
  - group → `"2026 / TE01-1"`
  - sub-group → `"2026 / TE01-1 / A"`
- Sort the resulting options by the path string so siblings group together.
- `limit(15)` retained (applied before mapping/sort).

Path builder: walk `$node = $s; while ($node) { names[] = $node->name; $node = $node->parent; }`
then `implode(' / ', array_reverse($names))`.

The option `id` is unchanged, so `studentIds` and `$activity->students()->sync(...)`
are untouched.

## Out of Scope (YAGNI)

- Matching the search term against parent/path text (still matches own name only).
- Making batches selectable.
- Client-side activity pages (this picker exists only on the program activity edit sheet).

## Testing

Livewire feature test (sqlite + RefreshDatabase): seed batch "2026" → group "TE01-1"
→ sub-group "A", acting as the program user; mount the sheet, call `searchStudents('')`,
assert `studentOptions` contains a `name` of `"2026 / TE01-1"` (group) and
`"2026 / TE01-1 / A"` (sub-group), and does NOT contain the bare batch "2026" as an option.
