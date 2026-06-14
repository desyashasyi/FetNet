# Student-Group Path Labels Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Show full hierarchy paths (batch / group / sub-group) as option labels in the activity edit sheet's Student Groups picker, so groups and sub-groups are distinguishable.

**Architecture:** Change only `searchStudents()` in the program activity edit sheet to eager-load ancestors and map each option's label to the `/`-joined ancestor path; values (ids) unchanged.

**Tech Stack:** Laravel 12, Livewire 4 (SFC), MaryUI, PHPUnit 11, sqlite `:memory:` tests.

---

## Reference Facts (verified)

- File: `resources/views/pages/program/data/activities/activity-edit-sheet.blade.php`.
- Current method (around lines 163–182):
  ```php
  public function searchStudents(string $value = ""): void
  {
      $program = $this->program();
      if (!$program) {
          $this->studentOptions = [];
          return;
      }
      $this->studentOptions = Student::where("program_id", $program->id)
          ->whereNotNull("parent_id")
          ->where(
              fn($q) => $q
                  ->where("name", "like", "%{$value}%")
                  ->orWhereIn("id", $this->studentIds),
          )
          ->orderBy("name")
          ->limit(15)
          ->get()
          ->map(fn($s) => ["id" => $s->id, "name" => $s->name])
          ->toArray();
  }
  ```
- `program()` resolves via the public `?int $programId` prop: `return $this->programId ? Program::find($this->programId) : null;`
- `Student` model (`app/Models/FetNet/Student.php`): `$guarded=[]`, `parent()` → `belongsTo(Student::class,'parent_id')`. Three levels: batch (parent_id null) → group → sub-group.
- Component name for Livewire tests: `pages::program.data.activities.activity-edit-sheet`.
- `/program` routes use `auth` middleware only (no role); tests can `actingAs` any user.
- Tests run inside the container: `docker compose exec -T app php artisan test --filter <Name>`.

---

## File Structure

- Modify `resources/views/pages/program/data/activities/activity-edit-sheet.blade.php` — `searchStudents()` only.
- Create `tests/Feature/FetNet/ActivityStudentPickerTest.php` — asserts path labels.

---

## Task 1: Path labels in `searchStudents`

**Files:**
- Modify: `resources/views/pages/program/data/activities/activity-edit-sheet.blade.php` (`searchStudents()`)
- Test: `tests/Feature/FetNet/ActivityStudentPickerTest.php`

- [ ] **Step 1: Write the failing test**

Create `tests/Feature/FetNet/ActivityStudentPickerTest.php`:

```php
<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ActivityStudentPickerTest extends TestCase
{
    use RefreshDatabase;

    private const SHEET = 'pages::program.data.activities.activity-edit-sheet';

    public function test_student_options_show_full_hierarchy_path(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        $batch = Student::create(['program_id' => $program->id, 'name' => '2026']);
        $group = Student::create(['program_id' => $program->id, 'name' => 'TE01-1', 'parent_id' => $batch->id]);
        $sub   = Student::create(['program_id' => $program->id, 'name' => 'A', 'parent_id' => $group->id]);

        $options = Livewire::actingAs($user)
            ->test(self::SHEET, ['programId' => $program->id])
            ->call('searchStudents', '')
            ->get('studentOptions');

        $labels = array_column($options, 'name');
        $ids    = array_column($options, 'id');

        $this->assertContains('2026 / TE01-1', $labels);       // group
        $this->assertContains('2026 / TE01-1 / A', $labels);   // sub-group
        $this->assertNotContains('2026', $labels);             // batch not selectable
        $this->assertContains($group->id, $ids);
        $this->assertContains($sub->id, $ids);
        $this->assertNotContains($batch->id, $ids);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `docker compose exec -T app php artisan test --filter ActivityStudentPickerTest`
Expected: FAIL — labels are the bare names (`'TE01-1'`, `'A'`), so `assertContains('2026 / TE01-1', ...)` fails.

- [ ] **Step 3: Implement path labels**

In `resources/views/pages/program/data/activities/activity-edit-sheet.blade.php`, replace the `searchStudents` body with:

```php
    public function searchStudents(string $value = ""): void
    {
        $program = $this->program();
        if (!$program) {
            $this->studentOptions = [];
            return;
        }

        $options = Student::where("program_id", $program->id)
            ->whereNotNull("parent_id")
            ->where(
                fn($q) => $q
                    ->where("name", "like", "%{$value}%")
                    ->orWhereIn("id", $this->studentIds),
            )
            ->with(["parent.parent"])
            ->orderBy("name")
            ->limit(15)
            ->get()
            ->map(fn($s) => ["id" => $s->id, "name" => $this->studentPath($s)])
            ->sortBy("name")
            ->values()
            ->toArray();

        $this->studentOptions = $options;
    }

    private function studentPath(Student $student): string
    {
        $names = [];
        for ($node = $student; $node; $node = $node->parent) {
            $names[] = $node->name;
        }

        return implode(" / ", array_reverse($names));
    }
```

Ensure `use App\Models\FetNet\Student;` is present at the top of the file (it already is).

- [ ] **Step 4: Run test to verify it passes**

Run: `docker compose exec -T app php artisan test --filter ActivityStudentPickerTest`
Expected: PASS (1 test).

- [ ] **Step 5: Clear views**

Run: `docker compose exec -T app php artisan view:clear`
Expected: "Compiled views cleared successfully."

- [ ] **Step 6: Commit**

```bash
git add resources/views/pages/program/data/activities/activity-edit-sheet.blade.php tests/Feature/FetNet/ActivityStudentPickerTest.php
git commit -m "feat: show full hierarchy path in activity student-group picker"
```

---

## Task 2: Verification

**Files:** none (verification only)

- [ ] **Step 1: Run the new test plus a sanity sweep of FetNet tests**

Run: `docker compose exec -T app php artisan test --filter "ActivityStudentPicker|Workload|LecturerWorkload"`
Expected: all PASS (path picker + the existing workload suite unaffected).

- [ ] **Step 2: Visual check**

Log in as a program user, open `/program/data/activities`, open an activity (Edit) or Add, and open the **Student Groups** picker. Confirm options read like `2026 / TE01-1` (group) and `2026 / TE01-1 / A` (sub-group), batches do not appear, and saving still attaches the chosen groups.

---

## Self-Review Notes

- **Spec coverage:** candidate set + filter unchanged (Task 1 Step 3); `with(['parent.parent'])` eager load; path label via ancestor walk; sort by path; ids unchanged; batches excluded; test asserts group + sub-group labels and batch exclusion (Task 1 Step 1). All mapped.
- **Types:** `searchStudents(string): void` sets `array $studentOptions` of `['id'=>int,'name'=>string]`; helper `studentPath(Student): string`. Consistent.
- **Placeholders:** none.
