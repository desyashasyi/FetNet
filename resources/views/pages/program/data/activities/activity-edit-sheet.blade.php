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

    public array $subjectOptions = [];
    public array $typeOptions = [];
    public array $teacherOptions = [];
    public array $studentOptions = [];
    public array $tagOptions = [];

    private function program(): ?Program
    {
        return $this->programId ? Program::find($this->programId) : null;
    }

    public function mount(): void
    {
        $this->loadOptions();
    }

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
    }

    #[On("tags-changed")]
    public function reloadTags(): void
    {
        $this->loadOptions();
    }

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
            ->with(["parent.parent"])
            ->orderBy("name")
            ->limit(500)
            ->get()
            ->map(fn($s) => ["id" => $s->id, "name" => $this->studentPath($s)])
            ->sortBy("name")
            ->values()
            ->toArray();
    }

    private function studentPath(Student $student): string
    {
        $names = [];
        for ($node = $student; $node; $node = $node->parent) {
            $names[] = $node->name;
        }

        return implode(" / ", array_reverse($names));
    }

    public function updatedSubjectId(): void
    {
        $this->subjectCredit = $this->subject_id
            ? Subject::find($this->subject_id)?->credit ?? 0
            : 0;
    }

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

    public function openManageTags(): void
    {
        $this->dispatch("open-tag-manager");
    }

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
            <x-choices label="Student Groups" searchable :search-function="'searchStudents'"
                       wire:model="studentIds" :options="$studentOptions" placeholder="Select groups..." />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
