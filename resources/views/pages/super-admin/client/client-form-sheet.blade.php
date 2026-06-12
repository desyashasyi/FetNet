<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\ClientLevel;
use App\Models\FetNet\ClusterBase;
use App\Models\FetNet\Faculty;
use App\Models\FetNet\University;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal    = false;
    public string $mode     = 'create';
    public ?int   $editId   = null;

    // Fields
    public string $username      = '';
    public string $email         = '';
    public string $password      = '';
    public string $description   = '';
    public ?int   $level_id      = null;
    public ?int   $university_id = null;
    public ?int   $faculty_id    = null;
    public string $clusterCode   = '';
    public string $clusterName   = '';

    public array $levelsOptions       = [];
    public array $universitiesOptions = [];
    public array $facultiesOptions    = [];

    // Faculty quick-create
    public bool   $facultyModal      = false;
    public ?int   $facultyUniversityId = null;
    public string $newFacultyCode    = '';
    public string $newFacultyName    = '';
    public string $newFacultyNameEng = '';

    // University quick-create
    public bool   $universityModal      = false;
    public string $newUniversityCode    = '';
    public string $newUniversityName    = '';
    public string $newUniversityNameEng = '';

    public function mount(): void { $this->loadOptions(); }

    private function loadOptions(): void
    {
        $this->levelsOptions = ClientLevel::all(['id', 'code', 'level'])
            ->map(fn($l) => ['id' => $l->id, 'name' => "{$l->code} | {$l->level}"])->toArray();

        $this->universitiesOptions = University::orderBy('code')->get(['id', 'code', 'name'])
            ->map(fn($u) => ['id' => $u->id, 'name' => "{$u->code} | {$u->name}"])->toArray();

        $this->loadFaculties();
    }

    private function loadFaculties(): void
    {
        $this->facultiesOptions = Faculty::when(
            $this->university_id, fn($q) => $q->where('university_id', $this->university_id)
        )->orderBy('code')->get(['id', 'code', 'name'])
            ->map(fn($f) => ['id' => $f->id, 'name' => "{$f->code} | {$f->name}"])->toArray();
    }

    public function updatedUniversityId(): void
    {
        $this->faculty_id = null;
        $this->loadFaculties();
    }

    public function isClusterLevel(): bool
    {
        if (! $this->level_id) return false;
        return ClientLevel::find($this->level_id)?->code === 'CLU';
    }

    #[On('open-client-create')]
    public function openCreate(): void
    {
        $this->reset(['username', 'email', 'password', 'description', 'level_id', 'university_id', 'faculty_id', 'clusterCode', 'clusterName', 'editId']);
        $this->mode = 'create';
        $this->loadOptions();
        $this->modal = true;
    }

    #[On('open-client-edit')]
    public function openEdit(int $id): void
    {
        $client = Client::with(['user', 'cluster'])->findOrFail($id);

        $this->editId        = $id;
        $this->mode          = 'edit';
        $this->description   = $client->description ?? '';
        $this->level_id      = $client->client_level_id;
        $this->university_id = $client->university_id;
        $this->faculty_id    = $client->faculty_id;
        $this->email         = $client->user?->email ?? '';
        $this->clusterCode   = $client->cluster?->code ?? '';
        $this->clusterName   = $client->cluster?->name ?? '';

        $this->loadFaculties();
        $this->modal = true;
    }

    protected function rules(): array
    {
        if ($this->mode === 'create') {
            $r = [
                'username'      => 'required|unique:users,name',
                'email'         => 'required|email|unique:users,email',
                'password'      => 'required|min:6',
                'description'   => 'required',
                'level_id'      => 'required|exists:fetnet_client_level,id',
                'university_id' => 'required|exists:institution_university,id',
                'faculty_id'    => 'required|exists:institution_faculty,id',
            ];
        } else {
            $r = [
                'description'   => 'required',
                'level_id'      => 'required|exists:fetnet_client_level,id',
                'university_id' => 'required|exists:institution_university,id',
                'faculty_id'    => 'required|exists:institution_faculty,id',
                'email'         => 'required|email',
            ];
        }
        if ($this->isClusterLevel()) {
            $r['clusterCode'] = 'required';
            $r['clusterName'] = 'required';
        }
        return $r;
    }

    public function save(): void
    {
        $this->validate();

        if ($this->mode === 'create') {
            $user = User::create([
                'name'     => $this->username,
                'email'    => $this->email,
                'password' => Hash::make($this->password),
            ]);
            $user->assignRole('client');

            $client = Client::create([
                'user_id'         => $user->id,
                'university_id'   => $this->university_id,
                'faculty_id'      => $this->faculty_id,
                'client_level_id' => $this->level_id,
                'description'     => $this->description,
            ]);
            $user->update(['client_id' => $client->id]);

            ClientConfig::create([
                'client_id' => $client->id, 'number_of_days' => 0, 'number_of_hours' => 0,
            ]);

            if ($this->isClusterLevel()) {
                ClusterBase::create([
                    'client_id' => $client->id,
                    'code'      => $this->clusterCode,
                    'name'      => $this->clusterName,
                ]);
            }

            $this->success('Client added successfully.', position: 'toast-top toast-center');
        } else {
            $client = Client::with(['user', 'cluster'])->findOrFail($this->editId);
            $client->update([
                'description'     => $this->description,
                'client_level_id' => $this->level_id,
                'university_id'   => $this->university_id,
                'faculty_id'      => $this->faculty_id,
            ]);
            $client->user?->update(['email' => $this->email]);

            if ($this->isClusterLevel()) {
                ClusterBase::updateOrCreate(
                    ['client_id' => $client->id],
                    ['code' => $this->clusterCode, 'name' => $this->clusterName]
                );
            } else {
                ClusterBase::where('client_id', $client->id)->delete();
            }

            $this->success('Client updated successfully.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('client-changed');
    }

    public function openFacultyCreate(): void
    {
        $this->facultyUniversityId = $this->university_id;
        $this->newFacultyCode      = '';
        $this->newFacultyName      = '';
        $this->newFacultyNameEng   = '';
        $this->facultyModal        = true;
    }

    public function saveFaculty(): void
    {
        $this->validate([
            'facultyUniversityId' => 'required|exists:institution_university,id',
            'newFacultyCode'      => 'required|string|max:10',
            'newFacultyName'      => 'required|string|max:100',
            'newFacultyNameEng'   => 'nullable|string|max:100',
        ]);

        $faculty = Faculty::create([
            'code'          => $this->newFacultyCode,
            'name'          => $this->newFacultyName,
            'name_eng'      => $this->newFacultyNameEng ?: null,
            'university_id' => $this->facultyUniversityId,
        ]);

        $this->university_id = $this->facultyUniversityId;
        $this->loadFaculties();
        $this->faculty_id = $faculty->id;

        $this->facultyModal = false;
        $this->success("Faculty '{$faculty->name}' added.", position: 'toast-top toast-center');
    }

    public function openUniversityCreate(): void
    {
        $this->newUniversityCode    = '';
        $this->newUniversityName    = '';
        $this->newUniversityNameEng = '';
        $this->universityModal      = true;
    }

    public function saveUniversity(): void
    {
        $this->validate([
            'newUniversityCode' => 'required|string|max:10',
            'newUniversityName' => 'required|string|max:100',
            'newUniversityNameEng' => 'nullable|string|max:100',
        ]);

        $university = University::create([
            'code'     => $this->newUniversityCode,
            'name'     => $this->newUniversityName,
            'name_eng' => $this->newUniversityNameEng ?: null,
        ]);

        $this->loadOptions();
        $this->facultyUniversityId = $university->id;

        $this->universityModal = false;
        $this->success("University '{$university->name}' added.", position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$mode === 'create' ? 'Add Client' : 'Edit Client'" separator box-class="!max-w-2xl mx-auto !rounded-t-2xl !mb-14" class="modal-bottom">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="grid grid-cols-3 gap-3">
                <x-choices label="Level" single searchable wire:model.live="level_id" :options="$levelsOptions" placeholder="Select" required />
                <div class="col-span-2">
                    <x-choices label="Faculty" single searchable wire:model="faculty_id" :options="$facultiesOptions" placeholder="Select faculty" required>
                        <x-slot:append>
                            <x-button icon="o-plus" class="btn-ghost btn-sm rounded-l-none border-l border-base-300" tooltip="Add faculty"
                                      wire:click.prevent="openFacultyCreate" />
                        </x-slot:append>
                    </x-choices>
                </div>
            </div>
            <div class="w-3/4">
                <x-choices label="University" single searchable wire:model.live="university_id" :options="$universitiesOptions" placeholder="Select university" required />
            </div>
            @if($this->isClusterLevel())
                <div class="grid grid-cols-4 gap-3">
                    <x-input label="Code" wire:model="clusterCode" placeholder="GRP1" required />
                    <div class="col-span-3">
                        <x-input label="Cluster Name" wire:model="clusterName" placeholder="Group 1" required />
                    </div>
                </div>
            @endif
            <x-input label="Description" wire:model="description" placeholder="Electrical Engineering Study Program" required />
            <div class="divider text-xs">User Account</div>
            @if($mode === 'create')
                <div class="grid grid-cols-2 gap-3">
                    <x-input label="Username" wire:model="username" placeholder="electrical.engineering" required />
                    <x-input label="Email"    wire:model="email"    placeholder="name@university.ac.id" type="email" required />
                </div>
                <div class="w-2/3">
                    <x-password label="Password" wire:model="password" placeholder="••••••••" right required />
                </div>
            @else
                <div class="w-5/6">
                    <x-input label="Email" wire:model="email" type="email" required />
                </div>
            @endif
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>

    <x-modal wire:model="facultyModal" title="Add Faculty" separator box-class="!max-w-md mx-auto">
        <x-form wire:submit="saveFaculty" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-choices label="University" single searchable wire:model="facultyUniversityId"
                       :options="$universitiesOptions" placeholder="Select university" required>
                <x-slot:append>
                    <x-button icon="o-plus" class="btn-ghost btn-sm rounded-l-none border-l border-base-300"
                              tooltip="Add university" wire:click.prevent="openUniversityCreate" />
                </x-slot:append>
            </x-choices>
            <div class="grid grid-cols-3 gap-3">
                <x-input label="Code" wire:model="newFacultyCode" placeholder="FTE" required />
                <div class="col-span-2">
                    <x-input label="Name" wire:model="newFacultyName" placeholder="Faculty of Technology" required />
                </div>
            </div>
            <x-input label="English Name" wire:model="newFacultyNameEng" placeholder="Faculty of Technology (optional)" />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('facultyModal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveFaculty" />
            </x-slot:actions>
        </x-form>
    </x-modal>

    <x-modal wire:model="universityModal" title="Add University" separator box-class="!max-w-sm mx-auto">
        <x-form wire:submit="saveUniversity" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="grid grid-cols-3 gap-3">
                <x-input label="Code" wire:model="newUniversityCode" placeholder="UPI" required />
                <div class="col-span-2">
                    <x-input label="Name" wire:model="newUniversityName" placeholder="Universitas Pendidikan Indonesia" required />
                </div>
            </div>
            <x-input label="English Name" wire:model="newUniversityNameEng" placeholder="Indonesia University of Education (optional)" />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('universityModal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveUniversity" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
