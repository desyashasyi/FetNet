---
name: fetnet-documentation
description: Use when adding a new feature or revising an existing one in the FetNet codebase — any new/changed Livewire SFC component (page or child), service method, model, job, event, notification, or migration. Every such unit must carry a complete, easy-to-understand doc comment. Documentation is part of "done", not an afterthought.
---

# FetNet: Always Document Features

## Rule

**Every new feature and every feature revision ships with complete, easy-to-understand documentation.** Writing the code is not finished until the description is written. This is mandatory, not optional.

Applies whenever you create or change:

- A **Livewire SFC component** — page (`⚡idx.blade.php`) or co-located child (`*-sheet.blade.php`, etc.): the file-top purpose block AND each method (action, `#[Computed]`, `#[On]`, `mount`, `with`, lifecycle hooks, search functions).
- A **service / helper method** (`app/Services/FetNet/`).
- A **model** (class purpose + table + key columns + relations).
- A **job, event, notification, or console command** (see [[fetnet-job-events]] for the job→event pattern itself).
- A **migration** that introduces a non-obvious table/column.

If you revise existing behavior, **update the existing doc comment** so it still matches the code — never leave a stale description.

## What "complete and easy to understand" means

A reader who has never seen the code should grasp, from the comment alone:

1. **What** it does — one plain sentence.
2. **Who** may call it / **when** — program/cluster scope, reactive prop dependency, the event that triggers it.
3. **Side effects** — DB writes, soft-delete cascades (subject → planning → activity), pivot syncs, dispatched Livewire/broadcast events, toasts.
4. **Inputs/outputs** worth noting — `@param` / `@return` for anything non-obvious (ids, nullable, array shapes, matrix structures).

Keep it tight. One sentence for trivial methods; a short block for anything with branching, guards, or side effects. Explain the **why** when the code looks surprising (deferred dispatch to avoid morphing a dialog shut, `withTrashed()` restore-instead-of-duplicate, high search limits so sub-groups aren't truncated).

## Format

Use PHPDoc `/** ... */` above the unit. English only.

Service / model methods:

```php
/**
 * Recap for everyone teaching in this program during the active period,
 * including lecturers whose home program is elsewhere (guests / cluster).
 */
public function forProgram(Program $program, ?int $activeSemesterId): array
```

Models — class-level doc with table, key columns, and one line per relation:

```php
/**
 * One guest-teacher link: a lecturer borrowed into a program from another program.
 * Pivot table `fetnet_teacher_guest`; one row per (program_id, teacher_id).
 */
class TeacherGuest extends Model
{
    /** The program borrowing the lecturer. */
    public function program() { ... }
}
```

Livewire single-file components — keep a file-top `/** ... */` block describing the component's purpose, scope, and reactive dependencies, then document each method:

```php
/**
 * Bottom-slide create/edit sheet for an Activity. Reactive on the parent's
 * programId + semesterId; on save upserts the subject's planning and syncs pivots.
 */
new class extends Component { ... }

/** Open the sheet in create mode; reset the form and prime picker option lists. */
#[On("open-activity-create")]
public function openCreate(?int $subjectId = null): void
```

## Quality bar (examples)

| Weak | Strong |
|------|--------|
| `// search` | `/** Live search for the Teachers picker: cluster teachers + this program's guests, by name/code; keeps already-selected ids in range. */` |
| `// toggle` | `/** Toggle a subject's planned state for this program+semester; withTrashed restores a removed plan instead of duplicating, marks the session dirty. */` |
| `// program` | `/** The signed-in user's program; scopes every query on this page. */` |
| (no comment) on a model | `/** A self-referential student node (batch → group → sub-group) via parent_id. Table fetnet_student. */` |

## SFC compiler caveat

In Livewire 4 single-file components, never write the word `new ` immediately before the `new class` declaration — not even in a comment — or the compiler rewrites the wrong token and breaks compilation. Put file-top doc blocks *above* the imports, or phrase comments to avoid a trailing bare `new`.

## Definition of done

Before claiming a feature/revision complete:

1. Every new/changed unit above has a doc comment.
2. Revised units have **updated** (not stale) comments.
3. Comments are English, explain guards + side effects, and would let a newcomer understand the unit without reading its body.
