<?php

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Semester;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool    $modal        = false;
    public ?int    $editId       = null;
    public ?int    $yearStart    = null;
    public string  $semName      = '';
    public ?int    $semType      = null;
    public ?int    $startMonth   = null;
    public ?int    $endMonth     = null;
    public ?string $lectureStart = null;
    public ?string $lectureEnd   = null;

    public array $monthOptions = [
        ['id' => 1,  'name' => 'January'],   ['id' => 2,  'name' => 'February'],
        ['id' => 3,  'name' => 'March'],     ['id' => 4,  'name' => 'April'],
        ['id' => 5,  'name' => 'May'],       ['id' => 6,  'name' => 'June'],
        ['id' => 7,  'name' => 'July'],      ['id' => 8,  'name' => 'August'],
        ['id' => 9,  'name' => 'September'], ['id' => 10, 'name' => 'October'],
        ['id' => 11, 'name' => 'November'],  ['id' => 12, 'name' => 'December'],
    ];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    #[On('open-semester-create')]
    public function openCreate(): void
    {
        $this->reset(['yearStart', 'semName', 'semType', 'startMonth', 'endMonth', 'lectureStart', 'lectureEnd', 'editId']);
        $this->modal = true;
    }

    #[On('open-semester-edit')]
    public function openEdit(int $id): void
    {
        $sem = Semester::with('academicYear')->findOrFail($id);

        $this->editId       = $id;
        $this->yearStart    = $sem->academicYear?->year_start;
        $this->semName      = $sem->name ?? '';
        $this->semType      = $sem->semester;
        $this->startMonth   = $sem->start_month;
        $this->endMonth     = $sem->end_month;
        $this->lectureStart = $sem->lecture_start?->format('Y-m-d');
        $this->lectureEnd   = $sem->lecture_end?->format('Y-m-d');
        $this->modal        = true;
    }

    public function save(): void
    {
        $this->validate([
            'yearStart'    => 'required|integer|min:2000|max:2099',
            'semName'      => 'required|string|max:50',
            'semType'      => 'required|in:1,2',
            'startMonth'   => 'required|integer|between:1,12',
            'endMonth'     => 'required|integer|between:1,12',
            'lectureStart' => 'nullable|date',
            'lectureEnd'   => 'nullable|date|after_or_equal:lectureStart',
        ]);

        $client = $this->client();

        $ay = AcademicYear::firstOrCreate(
            ['client_id' => $client->id, 'year_start' => $this->yearStart],
            ['is_active' => false]
        );

        $duplicate = Semester::where('academic_year_id', $ay->id)
            ->where('semester', $this->semType)
            ->when($this->editId, fn($q) => $q->where('id', '!=', $this->editId))
            ->exists();

        if ($duplicate) {
            $this->addError('semType', 'A semester of this type already exists for ' . $ay->label . '.');
            return;
        }

        $data = [
            'academic_year_id' => $ay->id,
            'client_id'        => $client->id,
            'year'             => $this->yearStart,
            'semester'         => $this->semType,
            'name'             => $this->semName,
            'start_month'      => $this->startMonth,
            'end_month'        => $this->endMonth,
            'lecture_start'    => $this->lectureStart ?: null,
            'lecture_end'      => $this->lectureEnd   ?: null,
        ];

        if ($this->editId) {
            Semester::findOrFail($this->editId)->update($data);
            $this->success('Semester updated.', position: 'toast-top toast-center');
        } else {
            Semester::create($data);
            $this->success('Semester added.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('semester-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Semester' : 'Add Semester'"
             separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-input label="Year Start" wire:model="yearStart" type="number" min="2000" max="2099"
                     placeholder="e.g. 2024" hint="e.g. 2024 for academic year 2024/2025" required />
            <div class="grid grid-cols-2 gap-3">
                <x-input label="Semester Name" wire:model="semName" placeholder="e.g. Odd" required />
                <x-choices label="Type" single wire:model="semType"
                           :options="[['id'=>1,'name'=>'Odd'],['id'=>2,'name'=>'Even']]"
                           placeholder="Select type" required />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-choices label="Start Month" single wire:model="startMonth"
                           :options="$monthOptions" placeholder="Select month" required />
                <x-choices label="End Month" single wire:model="endMonth"
                           :options="$monthOptions" placeholder="Select month" required />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-input label="Lecture Start" wire:model="lectureStart" type="date" />
                <x-input label="Lecture End"   wire:model="lectureEnd"   type="date" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
