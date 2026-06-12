---
name: fetnet-component-decomposition
description: Use when writing or editing any FetNet page blade under resources/views/pages/. Each role-feature page must be decomposed into co-located Livewire 4 single-file child components — never a single monolithic file. Children live next to ⚡idx.blade.php in the same feature folder.
---

# FetNet: Component Decomposition (Livewire 4, co-located)

## Rule

A role-feature page is **never** one monolithic Volt-style blade. Markup must be decomposed into small **Livewire 4 single-file child components** living in the **same folder** as the page. The page is a thin composition of `<livewire:pages::...>` tags.

> **Use Livewire 4 components, not Volt, not Blade `<x-*>` for the split.** Blade `<x-*>` stays for tiny presentational atoms (MaryUI primitives like `<x-header>`, `<x-card>`, `<x-button>`, `<x-modal>`, `<x-choices>`, etc.). Every new feature piece that holds state, owns a form, or owns a modal/sheet MUST be a Livewire child.

## Hard limits

- **Page blade > 150 lines → must extract.** Repeated card / row / sheet markup at any size must extract.
- **Each role-feature must have ≥2 components** (one page + one or more children).
- **The page should read like a layout outline** — heavy markup lives inside children.
- **Modal / bottom sheet MUST be its own Livewire child component.** A page never declares the full sheet markup inline.

## File layout (FetNet-specific)

FetNet routes via `Route::livewire('/...', 'pages::role.feature.⚡idx')`. The `pages::` namespace points to `resources/views/pages/` (registered by `livewire/livewire/config/livewire.php`). Children co-located in the same folder are reachable through the same namespace.

```
resources/views/pages/
└── {role}/
    └── {feature}/                          ← one folder per feature
        ├── ⚡idx.blade.php                  ← REQUIRED: the routed page (keep ⚡)
        ├── {piece}-sheet.blade.php         ← modal / bottom-sheet, owns its state
        ├── {piece}-summary.blade.php       ← table wrapper, receives row data
        ├── {piece}-card.blade.php          ← card-style item
        ├── {piece}-section.blade.php       ← composite header + content panel
        └── ...
```

### Hard rules for the feature folder

1. **Keep `⚡idx.blade.php` as the routed entry point.** Do not rename it — `routes/web.php` resolves `pages::{path}.⚡idx`. Renaming requires editing every `Route::livewire(...)` call.
2. **Children co-located.** Same folder. Name in kebab-case. No `livewire/` subdirectory.
3. **Children DO NOT carry the `⚡` prefix.** Only the routed page does. A child named `constraint-sheet.blade.php` is referenced as `<livewire:pages::client.time.teachers.constraint-sheet />`.
4. **Cross-feature reuse** lives in `resources/views/pages/shared/{piece}.blade.php` and is referenced as `<livewire:pages::shared.{piece} />`.

### Blade tag syntax

Children are reachable via the `pages::` namespace using the standard Livewire 4 namespaced syntax:

```blade
<livewire:pages::client.time.teachers.constraint-sheet
    :program-id="$filterProgramId"
    :constraint-type="$constraintType"
    :target="$target" />
```

Dot path = folder structure under `resources/views/pages/`. The `pages::` prefix is mandatory because the namespace is registered for that root.

## Mandatory single-file Livewire 4 child shape

```php
<?php

use App\Models\FetNet\Foo;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    #[Reactive] public ?int $programId = null;     // scalar reactive prop from parent
    public bool $modal = false;                    // own state
    public ?int $editId = null;

    #[Computed]
    public function program(): ?Foo
    {
        return $this->programId ? Foo::find($this->programId) : null;
    }

    #[On('open-something')]
    public function open(int $id): void
    {
        $this->editId = $id;
        $this->modal = true;
    }

    public function save(): void
    {
        // ... persist ...
        $this->modal = false;
        $this->dispatch('something-changed');
    }
}; ?>

<div>
    {{-- single root div, MaryUI markup, etc. --}}
</div>
```

### Rules for child class

- Anonymous class `new class extends Component { ... }` followed by `?>` and Blade markup. (No `#[Layout]` on children — only on the routed `⚡idx` page.)
- **Single root element in the view.** Use `<div>` as root. **Never use `<tr>` as a component root** — browser HTML parsing relocates stray `<tr>` outside a `<table>` context. Wrap the whole table inside one child with a `<div>` root instead of making per-row children.
- **Pass scalars / arrays via props**, not Eloquent models.
  - `#[Reactive]` is safe ONLY for scalar / array props. Never `#[Reactive]` on an Eloquent model or Collection — Livewire dehydrates to `class+id` and lazy-loads relations on hydrate, causing "Cannot mutate reactive prop" errors.
  - For summary rows: convert in parent's `with()` using `->map(fn($r) => ['id'=>...,'name'=>...])->values()->toArray()` and pass as array to child.
  - For an entity the child needs: pass its `id` and have the child resolve via `#[Computed]`.
- Use `#[Computed]` for derived data the view repeatedly reads.
- Trait `Mary\Traits\Toast` available in children if they emit their own toasts (e.g. after save).

## Parent → child & child → parent communication

- **Down (data)**: `<livewire:pages::... :prop="$value" />`. Add `#[Reactive]` on the child prop when the parent's value can change and the child must follow.
- **Down (action)**: parent calls `$this->dispatch('open-something', id: $x)`. Child listens with `#[On('open-something')]`.
- **Up (event)**: child calls `$this->dispatch('something-changed', id: $id)`. Parent listens with `#[On('something-changed')]`. Empty parent body is fine — its presence triggers re-render after the child saves.

Default dispatch is global within the page tree, so a child can also send to sibling children (e.g. a row component dispatching `open-edit` heard by the sheet component without going through the parent).

## Mandatory page shape after decomposition

```blade
<div>
    <x-header title="..." separator />

    {{-- Filter bar: stays inline if tightly coupled to parent state --}}
    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-select wire:model.live="filterProgramId" :options="$programOptions" />
        {{-- ... --}}
        @if($constraintType && $filterProgramId)
            <x-button label="Add" wire:click="openAddConstraint" class="btn-primary" />
        @endif
    </div>

    {{-- Summary table → child --}}
    @if($constraintType !== 'not_available')
        <livewire:pages::{role}.{feature}.numeric-summary
            :key="'numeric-'.$constraintType.'-'.($filterProgramId ?? 'all')"
            :rows="$constraintRows"
            :show-program-col="$showProgramCol"
            :can-add="(bool) $filterProgramId" />
    @endif

    {{-- Modal/sheet → child --}}
    <livewire:pages::{role}.{feature}.constraint-sheet
        :program-id="$filterProgramId"
        :constraint-type="$constraintType"
        :target="$target" />
</div>
```

Each `<livewire:...>` inside a loop or conditional that may toggle MUST carry a unique `:key="..."`.

The toast container `<x-toast />` is already rendered by `resources/views/layouts/{client,program,super-admin}.blade.php`. **Do not repeat `<x-toast />` inside the page.**

## Required decomposition checklist

For any feature page where the current monolith is > 150 lines, extract:

1. **Modal / bottom sheet → own child.** The child owns: `modal` flag, all form fields, save/validate methods, related grid state.
2. **Summary tables → one child per logical table.** Receives `rows` (array of arrays, not Eloquent), label data, and a `showProgramCol` / `canEdit` flag. Dispatches edit/delete events.
3. **Complex repeated row UI** (e.g. hover-preview grids inside table cells) → still inside the table-summary child since `<tr>` can't be a Livewire root, but factor the heavy `@php` blocks out of the loop body.
4. **Filter bar** — keep inline on the page when wire:model is bound to parent state; extract only if reused across pages (then put in `pages/shared/`).
5. **Empty state** → use `<livewire:pages::shared.empty-state>` if reused, else inline.

## Red flags / anti-patterns

| Anti-pattern | Fix |
|---|---|
| Single `⚡idx.blade.php` > 150 lines markup | Extract modal/sheet first, then tables |
| Modal/sheet declared inline in `⚡idx` | Move to `{feature}-sheet.blade.php` child, parent dispatches `open-...` |
| `<livewire:...>` inside loop without `:key="..."` | Add unique key |
| Per-row Livewire child with `<tr>` as root | Wrap the entire table in one summary child with `<div>` root |
| Passing Eloquent model as `#[Reactive]` prop | Pass scalar id; child resolves with `#[Computed]` |
| `<x-toast />` repeated in page | Layout already renders it — remove |
| Children dropped under `resources/views/livewire/` | FetNet decision: keep children co-located in `pages/{role}/{feature}/` |
| Renaming `⚡idx.blade.php` to `idx.blade.php` | Breaks `Route::livewire(...)` resolution. Keep the ⚡ |
| Child blade missing the `pages::` namespace in tag | `<livewire:client.time.teachers.foo />` will not resolve. Use `<livewire:pages::client.time.teachers.foo />` |
| Child class declares `#[Layout]` | Only the routed page (`⚡idx`) declares layout |

## Worked example: client/time/teachers

Before: one 1047-line `⚡idx.blade.php`.

After (co-located):
- `⚡idx.blade.php` — ~340 lines. Filter bar + composes three children + `with()` builds row arrays.
- `constraint-sheet.blade.php` — owns modal flag + form state + save methods + grid toggle methods + `searchTeachers`. Listens `open-constraint-add` / `open-constraint-edit` / `open-not-available-edit`. Dispatches `constraint-changed`.
- `numeric-summary.blade.php` — receives row array, dispatches `open-constraint-edit` + `constraint-delete-requested`.
- `not-available-summary.blade.php` — receives row array + grid labels, dispatches `open-not-available-edit`.

Parent state: filter only (`filterProgramId`, `target`, `constraintType`) + summary computation in `with()`. Parent listener: `#[On('constraint-changed')] refreshFromChild()` (empty body, triggers re-render) and `#[On('constraint-delete-requested')] deleteConstraintById($id)`.

## When you touch any page

1. Count markup lines. If > 150, identify modal/sheet first, then repeated table/row blocks.
2. Extract the modal/sheet into a `{feature}-sheet.blade.php` child that owns its own state.
3. Extract each summary table into a `{table}-summary.blade.php` child.
4. Replace inline markup in the page with `<livewire:pages::{role}.{feature}.{child} ... :key="..." />`.
5. Wire events: parent button → `dispatch('open-...')`, child `#[On('open-...')]` listener. Child save → `dispatch('something-changed')`, parent `#[On('something-changed')]` empty handler.
6. Page should now read as an outline: header + filter + child tags + sheet tag.
7. Verify: `php artisan view:cache` compiles clean and `php artisan route:list --path={your-path}` still shows the route.
