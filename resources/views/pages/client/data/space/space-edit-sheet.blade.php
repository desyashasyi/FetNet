<?php

use App\Models\FetNet\Building;
use App\Models\FetNet\Client;
use App\Models\FetNet\Faculty;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceType;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new class extends Component
{
    use Toast;

    public bool   $modal      = false;
    public ?int   $editId     = null;
    public string $name       = '';
    public string $code       = '';
    public string $floor      = '';
    public ?int   $capacity   = null;
    public ?int   $typeId     = null;
    public ?int   $buildingId = null;
    public ?int   $facultyId  = null;

    public array $buildingOptions = [];
    public array $facultyOptions  = [];
    public array $typeOptions     = [];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $this->loadOptions();
    }

    #[On('options-reload')]
    public function loadOptions(): void
    {
        $client = $this->client();
        if (! $client) return;

        $this->buildingOptions = Building::where('client_id', $client->id)
            ->orderByRaw('name REGEXP "^[A-Za-z]" DESC, name')
            ->limit(30)->get(['id', 'name'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->name])->toArray();

        $this->facultyOptions = Faculty::when($client->university_id, fn($q) => $q->where('university_id', $client->university_id))
            ->orderBy('name')->get(['id', 'name', 'code'])
            ->map(fn($f) => ['id' => $f->id, 'name' => $f->code ? "[{$f->code}] {$f->name}" : $f->name])
            ->toArray();

        $this->typeOptions = SpaceType::orderBy('name')->get(['id', 'name', 'code'])
            ->map(fn($t) => ['id' => $t->id, 'name' => $t->code ? "[{$t->code}] {$t->name}" : $t->name])
            ->toArray();
    }

    public function searchBuildings(string $value = ''): void
    {
        $client = $this->client();
        if (! $client) { $this->buildingOptions = []; return; }

        $this->buildingOptions = Building::where('client_id', $client->id)
            ->where(fn($q) => $q
                ->where('name', 'like', "%{$value}%")
                ->orWhere('code', 'like', "%{$value}%"))
            ->orderByRaw('name REGEXP "^[A-Za-z]" DESC, name')
            ->limit(30)->get(['id', 'name'])
            ->map(fn($b) => ['id' => $b->id, 'name' => $b->name])->toArray();
    }

    #[On('open-space-create')]
    public function openCreate(): void
    {
        $this->reset(['name', 'code', 'floor', 'capacity', 'typeId', 'buildingId', 'facultyId', 'editId']);
        $this->modal = true;
    }

    #[On('open-space-edit')]
    public function openEdit(int $id): void
    {
        $s                = Space::findOrFail($id);
        $this->editId     = $id;
        $this->name       = $s->name;
        $this->code       = $s->code      ?? '';
        $this->floor      = $s->floor     ?? '';
        $this->capacity   = $s->capacity;
        $this->typeId     = $s->type_id;
        $this->buildingId = $s->building_id;
        $this->facultyId  = $s->faculty_id;
        $this->modal = true;
    }

    protected function rules(): array
    {
        return [
            'name'       => 'required|max:200',
            'code'       => 'nullable|max:20',
            'floor'      => 'nullable|max:20',
            'capacity'   => 'nullable|integer|min:1',
            'typeId'     => 'nullable|exists:fetnet_space_type,id',
            'buildingId' => 'nullable|exists:fetnet_building,id',
            'facultyId'  => 'nullable',
        ];
    }

    public function save(): void
    {
        $this->validate();
        $client = $this->client();
        if (! $client) return;

        $data = [
            'client_id'   => $client->id,
            'name'        => $this->name,
            'code'        => trim($this->code) ?: null,
            'type_id'     => $this->typeId,
            'floor'       => trim($this->floor) ?: null,
            'capacity'    => $this->capacity,
            'building_id' => $this->buildingId,
            'faculty_id'  => $this->facultyId,
        ];

        if ($this->editId) {
            Space::findOrFail($this->editId)->update($data);
            $this->success('Space updated.', position: 'toast-top toast-center');
        } else {
            Space::create($data);
            $this->success('Space added.', position: 'toast-top toast-center');
        }

        $this->modal = false;
        $this->dispatch('space-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" :title="$editId ? 'Edit Space' : 'Add Space'"
             separator class="modal-bottom" box-class="!max-w-lg mx-auto !rounded-t-2xl !mb-14">
        <x-form wire:submit="save" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <div class="grid grid-cols-3 gap-3">
                <div class="col-span-2">
                    <x-input label="Name" wire:model="name" placeholder="Lab Komputer A" required />
                </div>
                <x-input label="Code" wire:model="code" placeholder="LAB-A" />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-choices label="Type" single wire:model="typeId"
                           :options="$typeOptions" placeholder="— None —" />
                <x-choices label="Building" single searchable clearable wire:model="buildingId"
                           :search-function="'searchBuildings'"
                           :options="$buildingOptions" placeholder="— None —" />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <x-input label="Floor" wire:model="floor" placeholder="2" />
                <x-input label="Capacity" wire:model="capacity" type="number" placeholder="40" />
            </div>
            <x-choices label="Faculty (optional)" single wire:model="facultyId"
                       :options="$facultyOptions" placeholder="— None —" />
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="save" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
