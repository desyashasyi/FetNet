<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal       = false;
    public ?int   $editId      = null;
    public string $code        = '';
    public string $univ_code   = '';
    public string $employee_id = '';
    public string $position    = '';
    public string $civil_grade = '';
    public string $front_title = '';
    public string $rear_title  = '';
    public string $name        = '';
    public string $email       = '';
    public string $phone       = '';
    public ?int   $programId   = null;
    public array  $programOptions = [];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    private function clientProgramIds(): array
    {
        $client = $this->client();
        return $client ? Program::where('client_id', $client->id)->pluck('id')->toArray() : [];
    }

    public function mount(): void { $this->loadProgramOptions(); }

    private function loadProgramOptions(): void
    {
        $client = $this->client();
        if (! $client) { $this->programOptions = []; return; }
        $this->programOptions = Program::where('client_id', $client->id)
            ->orderBy('abbrev')->limit(30)->get(['id', 'abbrev', 'name'])
            ->map(fn($p) => ['id' => $p->id, 'name' => "{$p->abbrev} — {$p->name}"])->toArray();
    }

    #[On('open-teacher-create')]
    public function openCreate(): void
    {
        $this->reset(['code', 'univ_code', 'employee_id', 'position', 'civil_grade', 'front_title', 'rear_title', 'name', 'email', 'phone', 'editId', 'programId']);
        $this->loadProgramOptions();
        $this->modal = true;
    }

    #[On('open-teacher-edit')]
    public function openEdit(int $id): void
    {
        $t                 = Teacher::findOrFail($id);
        $this->editId      = $id;
        $this->programId   = $t->program_id;
        $this->code        = $t->code         ?? '';
        $this->univ_code   = $t->univ_code    ?? '';
        $this->employee_id = $t->employee_id  ?? '';
        $this->position    = $t->position     ?? '';
        $this->civil_grade = $t->civil_grade  ?? '';
        $this->front_title = $t->front_title  ?? '';
        $this->rear_title  = $t->rear_title   ?? '';
        $this->name        = $t->name;
        $this->email       = $t->email        ?? '';
        $this->phone       = $t->phone        ?? '';
        $this->loadProgramOptions();
        $this->modal = true;
    }

    protected function rules(): array
    {
        return [
            'name'       => 'required',
            'programId'  => 'required|exists:institution_program,id',
            'code'       => 'nullable|size:3|alpha',
            'univ_code'  => 'nullable|max:4',
            'employee_id'=> 'nullable',
            'position'   => 'nullable|max:100',
            'civil_grade'=> 'nullable|max:50',
            'front_title'=> 'nullable',
            'rear_title' => 'nullable',
            'email'      => 'nullable|email',
            'phone'      => 'nullable',
        ];
    }

    public function save(): void
    {
        $this->validate();

        $ids = $this->clientProgramIds();
        if (! in_array($this->programId, $ids)) {
            $this->addError('programId', 'Invalid program.');
            return;
        }

        $usedCodes = Teacher::whereIn('program_id', $ids)
            ->when($this->editId, fn($q) => $q->where('id', '!=', $this->editId))
            ->whereNotNull('code')->pluck('code')->map(fn($c) => strtoupper($c))->toArray();

        $reqCode = strtoupper(trim($this->code));
        if (strlen($reqCode) === 3 && ! in_array($reqCode, $usedCodes)) {
            $code = $reqCode; $autoGen = false;
        } elseif ($this->editId) {
            $existing = Teacher::find($this->editId);
            $excCode  = strtoupper($existing?->code ?? '');
            if (strlen($excCode) === 3 && ! in_array($excCode, $usedCodes)) {
                $code = $excCode; $autoGen = false;
            } else { $code = Teacher::generateCode($this->name, $usedCodes); $autoGen = true; }
        } else { $code = Teacher::generateCode($this->name, $usedCodes); $autoGen = true; }

        $data = [
            'program_id'  => $this->programId,
            'code'        => $code,
            'univ_code'   => strtoupper(trim($this->univ_code)) ?: null,
            'employee_id' => $this->employee_id ?: null,
            'position'    => $this->position    ?: null,
            'civil_grade' => $this->civil_grade ?: null,
            'front_title' => $this->front_title ?: null,
            'rear_title'  => $this->rear_title  ?: null,
            'name'        => $this->name,
            'email'       => $this->email       ?: null,
            'phone'       => $this->phone       ?: null,
        ];

        if ($this->editId) {
            Teacher::findOrFail($this->editId)->update($data);
            $this->success('Teacher updated.' . ($autoGen ? " Code auto-generated: {$code}." : ''), position: 'toast-top toast-center');
        } else {
            Teacher::create($data);
            $this->success('Teacher added.' . ($autoGen ? " Code auto-generated: {$code}." : ''), position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('teacher-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Teacher' : 'Add Teacher'"
             separator class="modal-bottom" box-class="!max-w-xl mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="w-3/4">
                <x-choices label="Program" single searchable
                           wire:model="programId" :options="$programOptions"
                           placeholder="— Select Study Program —" required />
            </div>
            <x-input label="Full Name" wire:model="name" placeholder="Ahmad Fauzan" required />
            <div class="grid grid-cols-5 gap-3">
                <div class="col-span-2"><x-input label="Front Title" wire:model="front_title" placeholder="Dr." /></div>
                <div class="col-span-3"><x-input label="Rear Title" wire:model="rear_title" placeholder="M.T., Ph.D." /></div>
            </div>
            <div class="grid grid-cols-4 gap-3">
                <x-input label="Code" wire:model="code" placeholder="AFK" />
                <x-input label="Univ Code" wire:model="univ_code" placeholder="A001" />
                <div class="col-span-2">
                    <x-input label="Employee ID (NIP/NIDN)" wire:model="employee_id" placeholder="19800101 200901 1 001" />
                </div>
            </div>
            <div class="grid grid-cols-[1fr_auto] gap-3">
                <x-input label="Position (Jabatan)" wire:model="position" placeholder="e.g. Lektor Kepala" />
                <x-input label="Civil Grade (Golongan)" wire:model="civil_grade" placeholder="e.g. IV/a" />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-input label="Email" wire:model="email" type="email" placeholder="lecturer@univ.ac.id" />
                <x-input label="Phone" wire:model="phone" placeholder="08123456789" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
