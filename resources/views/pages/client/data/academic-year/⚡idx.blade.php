<?php

use App\Models\FetNet\AcademicYear;
use App\Models\FetNet\Client;
use App\Models\FetNet\Semester;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;

new #[Layout('layouts.client')] class extends Component
{
    use Toast;

    public bool $delModal = false;
    public ?int $deleteId = null;

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function openCreate(): void { $this->dispatch('open-semester-create'); }
    public function openEdit(int $id): void { $this->dispatch('open-semester-edit', id: $id); }

    public function setActive(int $semesterId): void
    {
        $client = $this->client();
        Semester::whereHas('academicYear', fn($q) => $q->where('client_id', $client->id))
            ->update(['is_active' => false]);
        Semester::find($semesterId)?->update(['is_active' => true]);
        $this->success('Active semester updated.', position: 'toast-top toast-center');
    }

    public function confirmDelete(int $id): void { $this->deleteId = $id; $this->delModal = true; }

    public function delete(): void
    {
        $sem = Semester::find($this->deleteId);
        if ($sem) {
            $ayId = $sem->academic_year_id;
            $sem->delete();
            if ($ayId && Semester::where('academic_year_id', $ayId)->doesntExist()) {
                AcademicYear::find($ayId)?->delete();
            }
        }
        $this->deleteId = null;
        $this->delModal = false;
        $this->warning('Semester deleted.', position: 'toast-top toast-center');
    }

    #[On('semester-changed')]
    public function refreshFromChild(): void {}

    public function with(): array
    {
        $client = $this->client();

        $semesters = $client
            ? Semester::with('academicYear')
                ->whereHas('academicYear', fn($q) => $q->where('client_id', $client->id))
                ->orderByDesc('year')->orderBy('semester')->get()
                ->map(fn($s) => tap($s, fn($item) => [
                    $item->ay_label = $s->academicYear?->label ?? ($s->year . '/'. ($s->year + 1)),
                    $item->ay_id    = $s->academic_year_id,
                ]))
            : collect();

        $headers = [
            ['key' => 'ay_label', 'label' => 'Academic Year', 'class' => 'w-3/12'],
            ['key' => 'name',     'label' => 'Semester',      'class' => 'w-2/12'],
            ['key' => 'period',   'label' => 'Period',        'class' => 'w-2/12'],
            ['key' => 'lecture',  'label' => 'Lecture Dates', 'class' => 'w-3/12'],
            ['key' => 'action',   'label' => '',              'class' => 'w-2/12 text-right'],
        ];

        return compact('semesters', 'headers');
    }
}; ?>

<div>
    <x-header title="Academic Year" subtitle="Manage academic years and semesters" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-button label="Add Semester" icon="o-plus" class="btn-primary" wire:click="openCreate" />
    </div>

    <x-card>
        <x-table :striped="true" :headers="$headers" :rows="$semesters" container-class="overflow-hidden" class="table-fixed">
            @scope('cell_ay_label', $row)
                <span class="font-medium">{{ $row->ay_label }}</span>
            @endscope

            @scope('cell_name', $row)
                <div class="flex items-center gap-1.5 flex-wrap">
                    <span class="font-medium text-sm">{{ $row->name ?? ($row->semester == 1 ? 'Odd' : 'Even') }}</span>
                    <x-badge value="{{ $row->semester == 1 ? 'Odd' : 'Even' }}" class="badge-neutral badge-xs" />
                    @if($row->is_active)
                        <x-badge value="Active" class="badge-success badge-xs" />
                    @else
                        <button wire:click="setActive({{ $row->id }})" class="text-xs text-primary hover:underline">Set active</button>
                    @endif
                </div>
            @endscope

            @scope('cell_period', $row)
                @php
                    $mn = [1=>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',
                           7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'];
                @endphp
                @if($row->start_month && $row->end_month)
                    <span class="text-sm">{{ $mn[$row->start_month] ?? '?' }} – {{ $mn[$row->end_month] ?? '?' }}</span>
                @else
                    <span class="text-base-content/30 text-sm italic">not set</span>
                @endif
            @endscope

            @scope('cell_lecture', $row)
                @if($row->lecture_start && $row->lecture_end)
                    <span class="text-sm">
                        {{ $row->lecture_start->format('d M Y') }} – {{ $row->lecture_end->format('d M Y') }}
                    </span>
                @else
                    <span class="text-base-content/30 text-sm italic">not set</span>
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

        @if($semesters->isEmpty())
            <p class="text-center text-base-content/40 py-8 text-sm">No semesters yet. Click "Add Semester" to get started.</p>
        @endif
    </x-card>

    <livewire:pages::client.data.academic-year.semester-form-sheet />

    <x-modal wire:model="delModal" title="Delete Semester"
             class="modal-bottom" box-class="!max-w-xs mx-auto !rounded-t-2xl !mb-14">
        <p class="text-base-content/70 text-sm">Delete this semester? If it is the last semester for its academic year, the academic year will also be removed.</p>
        <x-slot:actions>
            <x-button label="Cancel" icon="o-x-circle" wire:click="$set('delModal', false)" />
            <x-button label="Delete" icon="o-trash"    class="btn-error" wire:click="delete" />
        </x-slot:actions>
    </x-modal>
</div>
