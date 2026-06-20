<?php

use App\Models\FetNet\Activity;
use App\Models\FetNet\ActivityPlanning;
use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\ActivityType;
use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Student;
use App\Models\FetNet\Subject;
use App\Models\FetNet\Teacher;
//use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Bottom-slide create/edit sheet for an Activity on /program/data/activities.
 * Reactive on the parent's programId + semesterId. Picks a subject (which sets the
 * base duration from its credit), an activity type, extra duration, tags, teachers,
 * and student groups, then on save upserts the subject's ActivityPlanning for this
 * program + semester and syncs the teacher/student/tag pivots.
 *
 * Selector sources: teachers span the whole cluster plus this program's guest
 * teachers; student groups are the non-root nodes of the student hierarchy shown as a
 * "batch / group / sub-group" path so sub-groups are pickable.
 */
new class extends Component {
    use Toast;

    #[Reactive]
    public ?int $programId = null;
    #[Reactive]
    public ?int $semesterId = null;

    public bool $modal = false;
    public ?int $editId = null;
    public ?int $subject_id = null;
    public ?int $type_id = null;
    public int $extraDuration = 0;
    public int $subjectCredit = 0;
    public bool $active = true;
    public array $teacherIds = [];
    public array $studentIds = [];
    public array $tagIds = [];

    /** Optional batch (root node) to scope the Student Groups picker; null = all batches. */
    public ?int  $batchFilter = null;

    public array $subjectOptions = [];
    public array $typeOptions = [];
    public array $teacherOptions = [];
    public array $studentOptions = [];
    public array $batchOptions = [];
    public array $tagOptions = [];

    /** The active program (from the reactive programId prop), or null. */
    private function program(): ?Program
    {
        return $this->programId ? Program::find($this->programId) : null;
    }

    /** Seed the static option lists on first render. */
    public function mount(): void
    {
        $this->loadOptions();
    }

    /** Load the activity-type options (global) and tag options (this program). */
    public function loadOptions(): void
    {
        $program = $this->program();
        if (!$program) {
            return;
        }

        $this->typeOptions = ActivityType::orderBy("name")
            ->get()
            ->map(fn($t) => ["id" => $t->id, "name" => $t->name])
            ->toArray();

        $this->tagOptions = ActivityTag::where("program_id", $program->id)
            ->orderBy("name")
            ->get()
            ->map(fn($t) => ["id" => $t->id, "name" => $t->name])
            ->toArray();

        // Batch (root) options for the Student Groups filter.
        $this->batchOptions = Student::where("program_id", $program->id)
            ->whereNull("parent_id")
            ->orderBy("name")
            ->get(["id", "name"])
            ->map(fn($b) => ["id" => $b->id, "name" => $b->name])
            ->toArray();
    }

    /** Reload options after the tag manager reports a change. */
    #[On("tags-changed")]
    public function reloadTags(): void
    {
        $this->loadOptions();
    }

    /**
     * Live search for the Subject picker (this program only, by name or code). Always
     * keeps the currently-selected subject in the list so editing never loses it.
     */
    public function searchSubjects(string $value = ""): void
    {
        $program = $this->program();
        if (!$program) {
            $this->subjectOptions = [];
            return;
        }

        $results = Subject::where("program_id", $program->id)
            ->where(
                fn($q) => $q
                    ->where("name", "like", "%{$value}%")
                    ->orWhere("code", "like", "%{$value}%"),
            )
            ->orderBy("code")
            ->limit(30)
            ->get();

        if ($this->subject_id && !$results->contains("id", $this->subject_id)) {
            $forced = Subject::find($this->subject_id);
            if ($forced) {
                $results->prepend($forced);
            }
        }

        $this->subjectOptions = $results
            ->map(
                fn($s) => [
                    "id" => $s->id,
                    "name" => ($s->code ? "{$s->code} | " : "") . $s->name,
                ],
            )
            ->values()
            ->toArray();
    }

    /**
     * Live search for the Teachers picker. Candidate pool = teachers whose home
     * program is anywhere in this program's cluster, plus this program's guest
     * teachers, filtered by name/code. Already-selected ids are always kept in range.
     */
    public function searchTeachers(string $value = ""): void
    {
        $program = $this->program();
        if (!$program) {
            $this->teacherOptions = [];
            return;
        }

        $clusterProgramIds = collect([$program->id]);
        $clusterBaseId = Cluster::where("program_id", $program->id)->value(
            "cluster_base_id",
        );
        if ($clusterBaseId) {
            $clusterProgramIds = Cluster::where(
                "cluster_base_id",
                $clusterBaseId,
            )
                ->pluck("program_id")
                ->push($program->id)
                ->unique();
        }

        $guestIds = \DB::table("fetnet_teacher_guest")
            ->where("program_id", $program->id)
            ->pluck("teacher_id");

        $this->teacherOptions = Teacher::where(
            fn($q) => $q
                ->whereIn("program_id", $clusterProgramIds)
                ->orWhereIn("id", $guestIds),
        )
            ->where(
                fn($q) => $q
                    ->where("name", "like", "%{$value}%")
                    ->orWhere("code", "like", "%{$value}%")
                    ->orWhereIn("id", $this->teacherIds),
            )
            ->orderBy("name")
            ->limit(20)
            ->get()
            ->map(
                fn($t) => [
                    "id" => $t->id,
                    "name" => ($t->code ? "{$t->code} | " : "") . $t->name,
                ],
            )
            ->toArray();
    }

    /**
     * Live search for the Student Groups picker. Returns only non-root nodes (groups
     * and sub-groups) of this program's student hierarchy, each labelled with its full
     * "batch / group / sub-group" path. Limit is high (500) so deep sub-groups aren't
     * truncated out of the list.
     */
    public function searchStudents(string $value = ""): void
    {
        $program = $this->program();
        if (!$program) {
            $this->studentOptions = [];
            return;
        }
        $selected = $this->studentIds;

        $query = Student::where("program_id", $program->id)->whereNotNull("parent_id");

        // Scope to the chosen batch (its groups + sub-groups); already-selected nodes stay
        // visible so their labels still render even if they belong to another batch.
        if ($this->batchFilter) {
            $descendants = $this->batchDescendantIds($this->batchFilter);
            $query->where(fn($q) => $q->whereIn("id", $descendants)->orWhereIn("id", $selected));
        }

        $this->studentOptions = $query
            ->where(fn($q) => $q->where("name", "like", "%{$value}%")->orWhereIn("id", $selected))
            ->with(["parent.parent"])
            ->orderBy("name")
            ->limit(500)
            ->get()
            ->map(fn($s) => ["id" => $s->id, "name" => $this->studentPath($s)])
            ->sortBy("name")
            ->values()
            ->toArray();
    }

    /** Re-filter the Student Groups picker when the batch filter changes. */
    public function updatedBatchFilter(): void
    {
        $this->searchStudents();
    }

    /** All descendant node ids (groups + sub-groups, any depth) under a batch root. */
    private function batchDescendantIds(int $batchId): array
    {
        $ids      = [];
        $frontier = [$batchId];

        while ($frontier) {
            $children = Student::whereIn("parent_id", $frontier)->pluck("id")->all();
            $children = array_values(array_diff($children, $ids));
            if (! $children) break;
            $ids      = array_merge($ids, $children);
            $frontier = $children;
        }

        return $ids;
    }

    /** Build a student's display path by walking parent links: "2026 / TE01-7 / A". */
    private function studentPath(Student $student): string
    {
        $names = [];
        for ($node = $student; $node; $node = $node->parent) {
            $names[] = $node->name;
        }

        return implode(" / ", array_reverse($names));
    }

    /** When the subject changes, refresh the base credit (drives total duration). */
    public function updatedSubjectId(): void
    {
        $this->subjectCredit = $this->subject_id
            ? Subject::find($this->subject_id)?->credit ?? 0
            : 0;
    }

    /**
     * Open the sheet in create mode. Resets the form, defaults Active on, optionally
     * preselects a subject (prefilling its credit), and primes all picker option lists.
     */
    #[On("open-activity-create")]
    public function openCreate(?int $subjectId = null): void
    {
        $this->reset([
            "subject_id",
            "type_id",
            "extraDuration",
            "subjectCredit",
            "teacherIds",
            "studentIds",
            "tagIds",
            "batchFilter",
            "editId",
        ]);
        $this->active = true;
        $this->subject_id = $subjectId;
        if ($subjectId) {
            $this->subjectCredit = Subject::find($subjectId)?->credit ?? 0;
        }
        $this->loadOptions();
        $this->searchSubjects();
        $this->searchTeachers();
        $this->searchStudents();
        $this->modal = true;
    }

    /**
     * Open the sheet in edit mode for one activity: load its planning/teachers/
     * students/tags into the form, derive extra duration as (duration - credit), and
     * prime the picker option lists.
     */
    #[On("open-activity-edit")]
    public function openEdit(int $id): void
    {
        $a = Activity::with([
            "planning",
            "teachers",
            "students",
            "tags",
        ])->findOrFail($id);
        $this->editId = $id;
        $this->batchFilter = null;
        $this->subject_id = $a->planning?->subject_id;
        $this->type_id = $a->type_id;
        $this->active = (bool) $a->active;
        $this->subjectCredit = $a->planning?->subject?->credit ?? 0;
        $this->extraDuration = max(0, $a->duration - $this->subjectCredit);
        $this->teacherIds = $a->teachers->pluck("id")->toArray();
        $this->studentIds = $a->students->pluck("id")->toArray();
        $this->tagIds = $a->tags->pluck("id")->toArray();
        $this->loadOptions();
        $this->searchSubjects();
        $this->searchTeachers();
        $this->searchStudents();
        $this->modal = true;
    }

    /** Open the tag-manager sheet. */
    public function openManageTags(): void
    {
        $this->dispatch("open-tag-manager");
    }

    /**
     * Validate and persist the activity. Upserts (and restores if soft-deleted) the
     * subject's ActivityPlanning for this program + semester, sets duration to
     * credit + extra, creates or updates the Activity, syncs teacher/student/tag
     * pivots, closes the sheet, and emits 'activity-changed' for the parent.
     */
    public function save(): void
    {
        $this->validate([
            "subject_id" => "required|exists:fetnet_subject,id",
            "extraDuration" => "integer|min:0|max:8",
        ]);

        $program = $this->program();
        $credit = Subject::find($this->subject_id)?->credit ?? 0;

        $planning = ActivityPlanning::withTrashed()->firstOrCreate(
            [
                "subject_id" => $this->subject_id,
                "program_id" => $program->id,
                "semester_id" => $this->semesterId,
            ],
            [],
        );
        if ($planning->trashed()) {
            $planning->restore();
        }

        $data = [
            "planning_id" => $planning->id,
            "type_id" => $this->type_id,
            "duration" => $credit + $this->extraDuration,
            "active" => $this->active,
        ];

        if ($this->editId) {
            $activity = Activity::findOrFail($this->editId);
            $activity->update($data);
        } else {
            $activity = Activity::create(
                array_merge($data, ["program_id" => $program->id]),
            );
        }

        $activity->teachers()->sync($this->teacherIds);
        $activity->students()->sync($this->studentIds);
        $activity->tags()->sync($this->tagIds);

        $this->editId
            ? $this->success(
                "Activity updated.",
                position: "toast-top toast-center",
            )
            : $this->success(
                "Activity added.",
                position: "toast-top toast-center",
            );

        $this->modal = false;
        $this->dispatch("activity-changed");
    }
};
?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Activity' : 'Add Activity'"
             separator class="modal-bottom" box-class="!max-w-2xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="flex items-end gap-3">
                <div class="flex-1">
                    <x-choices label="Subject" single searchable :search-function="'searchSubjects'"
                               wire:model="subject_id" :options="$subjectOptions"
                               placeholder="Select subject" required />
                </div>
                <div class="pb-1">
                    <x-toggle label="Active" wire:model="active" class="toggle-primary" />
                </div>
            </div>
            <div class="grid grid-cols-[1fr_auto_1fr] gap-3 items-start">
                <x-choices label="Activity Type" single searchable wire:model="type_id"
                           :options="$typeOptions" placeholder="-- Select type --" />
                <x-input label="Extra Duration (hrs)" wire:model.live="extraDuration"
                         type="number" min="0" max="8" class="w-28"
                         :hint="$subjectCredit ? $subjectCredit.'+'. $extraDuration.'='.($subjectCredit + $extraDuration) : ''" />
                <div>
                    <x-choices label="Tags" searchable wire:model="tagIds" :options="$tagOptions" placeholder="Select tags..." />
                    <button type="button" wire:click="openManageTags"
                            class="text-xs text-primary hover:underline mt-1 block">Manage tags</button>
                </div>
            </div>
            <x-choices label="Teachers" searchable :search-function="'searchTeachers'"
                       wire:model="teacherIds" :options="$teacherOptions" placeholder="Select teachers..." />
            @if(count($batchOptions))
            <x-choices label="Batch (filter groups)" single searchable wire:model.live="batchFilter"
                       :options="$batchOptions" placeholder="— All batches —" clearable
                       hint="Pick a batch to narrow the groups below" />
            @endif
            <x-choices label="Student Groups" searchable :search-function="'searchStudents'"
                       wire:model="studentIds" :options="$studentOptions" placeholder="Select groups..." />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
