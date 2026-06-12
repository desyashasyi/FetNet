<?php

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use WithPagination, Toast;

    public string $search          = '';
    public ?int   $filterProgramId = null;
    public bool   $delModal        = false;
    public ?int   $deleteId        = null;
    public array  $programOptions  = [];

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

    public function updatedSearch(): void          { $this->resetPage(); }
    public function updatedFilterProgramId(): void { $this->resetPage(); }

    public function openCreate(): void { $this->dispatch('open-teacher-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-teacher-edit', id: $id); }

    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    public function delete(): void
    {
        Teacher::findOrFail($this->deleteId)->delete();
        $this->delModal = false; $this->deleteId = null;
        $this->warning('Teacher deleted.', position: 'toast-top toast-center');
    }

    #[On('teacher-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        $ids = $this->clientProgramIds();

        $headers = [
            ['key' => 'code',         'label' => 'Code',     'class' => 'w-1/12'],
            ['key' => 'univ_code',    'label' => 'Univ Code','class' => 'w-1/12'],
            ['key' => 'full_name',    'label' => 'Name',     'class' => 'w-3/12'],
            ['key' => 'study_program','label' => 'Program',  'class' => 'w-2/12'],
            ['key' => 'email',        'label' => 'Email',    'class' => 'w-2/12 max-w-0 truncate'],
            ['key' => 'phone',        'label' => 'Phone',    'class' => 'w-1/12'],
            ['key' => 'action',       'label' => '',         'class' => 'w-2/12 text-right'],
        ];

        $filterIds = $this->filterProgramId ? [$this->filterProgramId] : $ids;

        $teachers = Teacher::with('program:id,abbrev,name')
            ->whereIn('program_id', count($filterIds) ? $filterIds : [0])
            ->when($this->search, fn($q) => $q
                ->where('name',         'like', "%{$this->search}%")
                ->orWhere('code',        'like', "%{$this->search}%")
                ->orWhere('employee_id', 'like', "%{$this->search}%"))
            ->orderBy('name')->paginate(6)
            ->through(fn($t) => tap($t, fn($item) => [
                $item->full_name     = $t->full_name,
                $item->study_program = $t->program?->abbrev ?? '-',
                $item->program_name  = $t->program?->name  ?? '-',
            ]));

        return compact('headers', 'teachers');
    }
}; ?>

<div>
    <x-header title="Teachers" subtitle="All teachers across programs" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-choices single searchable wire:model.live="filterProgramId" :options="$programOptions"
                   placeholder="— All Programs —" clearable class="w-max min-w-48" />
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$teachers" with-pagination container-class="overflow-hidden" class="table-fixed">
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <div x-data="{ open: false, above: false }" @click.outside="open = false" class="relative">
                        <button @click="above = $el.getBoundingClientRect().top > window.innerHeight / 2; open = !open"
                                class="btn btn-ghost btn-sm btn-square" title="Detail">
                            <x-icon name="o-eye" class="w-4 h-4" />
                        </button>
                        <div x-show="open" x-cloak :class="above ? 'bottom-full mb-1' : 'top-full mt-1'"
                             class="absolute right-0 z-50 w-72 bg-base-100 border border-base-200 rounded-xl shadow-xl p-4 text-xs space-y-1.5">
                            <p class="font-semibold text-sm text-base-content mb-2">{{ $row->full_name }}</p>
                            @php
                                $rows = [
                                    ['Program',      $row->study_program . ' — ' . $row->program_name],
                                    ['Code',         $row->code],
                                    ['Univ Code',    $row->univ_code],
                                    ['NIP/NIDN',     $row->employee_id],
                                    ['Position',     $row->position],
                                    ['Civil Grade',  $row->civil_grade],
                                    ['Email',        $row->email],
                                    ['Phone',        $row->phone],
                                ];
                            @endphp
                            @foreach($rows as [$label, $val])
                                @if($val)
                                <div class="flex gap-2">
                                    <span class="text-base-content/40 w-24 shrink-0">{{ $label }}</span>
                                    <span class="text-base-content font-medium break-all">{{ $val }}</span>
                                </div>
                                @endif
                            @endforeach
                        </div>
                    </div>
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>

    <livewire:pages::client.data.teachers.teacher-edit-sheet />

    <x-modal wire:model="delModal" title="Delete Teacher" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this teacher? They will be removed from all activities.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
