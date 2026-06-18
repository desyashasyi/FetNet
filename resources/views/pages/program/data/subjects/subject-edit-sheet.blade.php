<?php

use App\Models\FetNet\CurriculumYear;
use App\Models\FetNet\Program;
use App\Models\FetNet\Specialization;
use App\Models\FetNet\Subject;
use App\Models\FetNet\SubjectType;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;
use Livewire\Attributes\Reactive;
use Livewire\Component;
use Mary\Traits\Toast;

/**
 * Create/edit sheet for a Subject, reactive on the parent's programId and a default
 * curriculum year. Offers curriculum-year / specialization / type pickers (computed,
 * program-scoped). Validates a unique code, then emits 'subject-changed' on save.
 */
new class extends Component
{
    use Toast;

    #[Reactive] public ?int $programId = null;
    #[Reactive] public ?int $defaultYearId = null;

    public bool   $modal              = false;
    public ?int   $editId             = null;
    public string $code               = '';
    public string $name               = '';
    public int    $credit             = 2;
    public ?int   $semester           = null;
    public ?int   $curriculum_year_id = null;
    public ?int   $specialization_id  = null;
    public ?int   $type_id            = null;

    public array $semesterOptions = [
        ['id' => 1, 'name' => '1'], ['id' => 2, 'name' => '2'],
        ['id' => 3, 'name' => '3'], ['id' => 4, 'name' => '4'],
        ['id' => 5, 'name' => '5'], ['id' => 6, 'name' => '6'],
        ['id' => 7, 'name' => '7'], ['id' => 8, 'name' => '8'],
    ];

    /** Specialization picker options ("CODE | Name") for the program. */
    #[Computed] public function specializationOptions(): array {
        if (!$this->programId) return [];
        return Specialization::where('program_id', $this->programId)->orderBy('code')->get()
            ->map(fn($s) => ['id' => $s->id, 'name' => "{$s->code} | {$s->name}"])->toArray();
    }

    /** Subject-type picker options ("CODE | Name") for the program. */
    #[Computed] public function typeOptions(): array {
        if (!$this->programId) return [];
        return SubjectType::where('program_id', $this->programId)->orderBy('code')->get()
            ->map(fn($t) => ['id' => $t->id, 'name' => "{$t->code} | {$t->name}"])->toArray();
    }

    /** Curriculum-year picker options (newest first) for the program. */
    #[Computed] public function curriculumYearOptions(): array {
        if (!$this->programId) return [];
        return CurriculumYear::where('program_id', $this->programId)->orderByDesc('year')->get()
            ->map(fn($y) => ['id' => $y->id, 'name' => $y->year])->toArray();
    }

    /** Bust the cached option lists when a lookup (year/spec/type) changes. */
    #[On('refresh-subject-options')]
    public function reloadOpts(): void
    {
        unset($this->specializationOptions, $this->typeOptions, $this->curriculumYearOptions);
    }

    /** Open the sheet for a new subject (defaults credit 2 + the active year). */
    #[On('open-subject-create')]
    public function openCreate(): void
    {
        $this->reset(['code', 'name', 'credit', 'semester', 'curriculum_year_id', 'specialization_id', 'type_id', 'editId']);
        $this->credit = 2;
        $this->curriculum_year_id = $this->defaultYearId;
        $this->modal = true;
    }

    /** Open the sheet prefilled from an existing subject. */
    #[On('open-subject-edit')]
    public function openEdit(int $id): void
    {
        $s                        = Subject::findOrFail($id);
        $this->editId             = $id;
        $this->code               = $s->code;
        $this->name               = $s->name;
        $this->credit             = $s->credit;
        $this->semester           = $s->semester;
        $this->curriculum_year_id = $s->curriculum_year_id;
        $this->specialization_id  = $s->specialization_id;
        $this->type_id            = $s->type_id;
        $this->modal = true;
    }

    /** Validation rules; code uniqueness ignores the current row when editing. */
    protected function rules(): array
    {
        $unique = 'required|unique:fetnet_subject,code';
        if ($this->editId) $unique .= ',' . $this->editId;
        return [
            'code'   => $unique,
            'name'   => 'required',
            'credit' => 'required|integer|min:1|max:10',
        ];
    }

    /** Validate and create/update the subject for the program, then emit 'subject-changed'. */
    public function save(): void
    {
        $this->validate();
        $data = [
            'code'               => $this->code,
            'name'               => $this->name,
            'credit'             => $this->credit,
            'semester'           => $this->semester,
            'curriculum_year_id' => $this->curriculum_year_id,
            'specialization_id'  => $this->specialization_id,
            'type_id'            => $this->type_id,
        ];

        if ($this->editId) {
            Subject::findOrFail($this->editId)->update($data);
            $this->success('Subject updated.', position: 'toast-top toast-center');
        } else {
            Subject::create(array_merge($data, ['program_id' => $this->programId]));
            $this->success('Subject added.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('subject-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Subject' : 'Add Subject'"
             separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="flex gap-3 items-end">
                <div class="flex-1">
                    <x-input label="Subject Name" wire:model="name" placeholder="Electrical Machines I" required />
                </div>
                <div class="w-32">
                    <x-select label="Curriculum Year" wire:model="curriculum_year_id"
                              :options="$this->curriculumYearOptions" placeholder="—" />
                </div>
            </div>
            <div class="grid grid-cols-5 gap-3">
                <div class="col-span-2">
                    <x-input label="Code" wire:model="code" placeholder="ELC301" required />
                </div>
                <x-input label="SKS" wire:model="credit" type="number" min="1" max="10" required />
                <div class="col-span-1">
                    <x-select label="Semester" wire:model="semester"
                              :options="$semesterOptions" placeholder="-" />
                </div>
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-choices label="Specialization" single searchable wire:model="specialization_id"
                           :options="$this->specializationOptions" placeholder="-- None --" />
                <x-choices label="Type" single searchable wire:model="type_id"
                           :options="$this->typeOptions" placeholder="-- None --" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
