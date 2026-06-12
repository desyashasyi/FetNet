<?php

use App\Models\FetNet\Cluster;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithPagination;
use Mary\Traits\Toast;

new #[Layout('layouts.program')] class extends Component
{
    use WithPagination, Toast;

    public string $search   = '';
    public bool   $delModal = false;
    public ?int   $deleteId = null;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    private function clusterProgramIds(Program $program): array
    {
        $entry = Cluster::where('program_id', $program->id)->first();
        if (! $entry) return [$program->id];
        return Cluster::where('cluster_base_id', $entry->cluster_base_id)
            ->pluck('program_id')->toArray();
    }

    public function updatedSearch(): void { $this->resetPage(); }

    public function openCreate(): void { $this->dispatch('open-teacher-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-teacher-edit', id: $id); }
    public function openGuestSearch(): void { $this->dispatch('open-guest-search'); }
    public function openImport(): void { $this->dispatch('open-teacher-import'); }

    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    public function delete(): void
    {
        Teacher::findOrFail($this->deleteId)->delete();
        $this->delModal = false; $this->deleteId = null;
        $this->warning('Teacher deleted.', position: 'toast-top toast-center');
    }

    public function removeGuestTeacher(int $teacherId): void
    {
        $this->program()->guestTeachers()->detach($teacherId);
        $this->success('Guest teacher removed.', position: 'toast-top toast-center');
    }

    #[On('teacher-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        $program   = $this->program();
        $ids       = $program ? $this->clusterProgramIds($program) : [];
        $inCluster = count($ids) > 1;

        $headers = [
            ['key' => 'code',      'label' => 'Code',      'class' => 'w-1/12'],
            ['key' => 'univ_code', 'label' => 'Univ Code', 'class' => 'w-1/12'],
            ['key' => 'full_name', 'label' => 'Name',      'class' => $inCluster ? 'w-3/12' : 'w-4/12'],
        ];
        if ($inCluster) $headers[] = ['key' => 'study_program', 'label' => 'Program', 'class' => 'w-1/12'];
        $headers[] = ['key' => 'guest_info', 'label' => 'Guest At', 'class' => 'w-1/12'];
        $headers[] = ['key' => 'email',      'label' => 'Email',    'class' => 'w-2/12 max-w-0 truncate'];
        $headers[] = ['key' => 'phone',      'label' => 'Phone',    'class' => 'w-1/12'];
        $headers[] = ['key' => 'action',     'label' => '',         'class' => 'w-2/12 text-right'];

        $ownTeachers = Teacher::with(['program:id,abbrev,name', 'guestPrograms:id,abbrev'])
                ->whereIn('program_id', $ids ?: [0])
                ->when($this->search, fn($q) => $q
                    ->where('name',         'like', "%{$this->search}%")
                    ->orWhere('code',        'like', "%{$this->search}%")
                    ->orWhere('employee_id', 'like', "%{$this->search}%"))
                ->orderBy('name')->paginate(6)
                ->through(fn($t) => tap($t, fn($item) => [
                    $item->full_name     = $t->full_name,
                    $item->study_program = $t->program?->abbrev ?? '-',
                    $item->program_name  = $t->program?->name  ?? '-',
                    $item->guest_abbrevs = $t->guestPrograms->pluck('abbrev')->toArray(),
                ]));

        $guestTeachers = $program
            ? $program->guestTeachers()
                ->with('program:id,abbrev,name')
                ->when($this->search, fn($q) => $q
                    ->where('fetnet_teacher.name',         'like', "%{$this->search}%")
                    ->orWhere('fetnet_teacher.code',        'like', "%{$this->search}%")
                    ->orWhere('fetnet_teacher.employee_id', 'like', "%{$this->search}%"))
                ->orderBy('fetnet_teacher.name')->get()
                ->map(fn($t) => tap($t, fn($item) => [
                    $item->full_name     = $t->full_name,
                    $item->study_program = $t->program?->abbrev ?? '-',
                    $item->program_name  = $t->program?->name  ?? '-',
                    $item->guest_abbrevs = [],
                ]))
            : collect();

        return [
            'inCluster'    => $inCluster,
            'headers'      => $headers,
            'guestHeaders' => $headers,
            'ownTeachers'  => $ownTeachers,
            'guestTeachers'=> $guestTeachers,
        ];
    }
}; ?>

<div>
    <x-header title="Teachers" subtitle="Manage lecturers & instructors" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-input placeholder="Search..." wire:model.live.debounce="search" icon="o-magnifying-glass" clearable />
        <x-button label="Import" icon="o-arrow-up-tray" class="btn-ghost btn-sm" wire:click="openImport" />
        <x-button label="Guest Teacher" icon="o-user-plus" class="btn-ghost btn-sm" wire:click="openGuestSearch" />
        <x-button label="Add" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$ownTeachers" with-pagination container-class="overflow-hidden" class="table-fixed">
            @scope('cell_guest_info', $row)
                @if(count($row->guest_abbrevs))
                    <div x-data="{ open: false }" class="relative">
                        <x-button label="{{ count($row->guest_abbrevs) }}" icon="o-building-office"
                                  class="btn-ghost btn-xs" x-on:click="open = !open" />
                        <div x-show="open" x-on:click.outside="open = false"
                             class="absolute z-50 left-0 top-6 bg-base-100 border border-base-200 rounded-lg shadow-lg p-2 min-w-max text-xs space-y-1">
                            @foreach($row->guest_abbrevs as $abbrev)
                                <div class="px-2 py-0.5">{{ $abbrev }}</div>
                            @endforeach
                        </div>
                    </div>
                @else
                    <span class="text-base-content/20">—</span>
                @endif
            @endscope
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-pencil" class="btn-ghost btn-sm btn-square"
                              wire:click="openEdit({{ $row->id }})" tooltip="Edit" />
                    <x-button icon="o-trash"  class="btn-ghost btn-sm btn-square text-error"
                              wire:click="confirmDelete({{ $row->id }})" tooltip="Delete" />
                </div>
            @endscope
        </x-table>
    </x-card>

    @if($guestTeachers->isNotEmpty())
    <x-card title="Guest Teachers" class="mt-4">
        <x-table :striped="true" :headers="$guestHeaders" :rows="$guestTeachers" container-class="overflow-hidden" class="table-fixed">
            @scope('cell_guest_info', $row)
                <x-badge value="Guest" class="badge-warning badge-sm badge-dash" />
            @endscope
            @scope('cell_action', $row)
                <div class="flex justify-end gap-1">
                    <x-button icon="o-x-mark" class="btn-ghost btn-sm btn-square text-error"
                              wire:click="removeGuestTeacher({{ $row->id }})" tooltip="Remove guest" />
                </div>
            @endscope
        </x-table>
    </x-card>
    @endif

    <livewire:pages::program.data.teachers.teacher-edit-sheet />
    <livewire:pages::program.data.teachers.guest-search-sheet />
    <livewire:pages::program.data.teachers.import-sheet />

    <x-modal wire:model="delModal" title="Delete Teacher" box-class="!max-w-sm">
        <p class="text-base-content/70 text-sm">Delete this teacher? They will be removed from all activities.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
