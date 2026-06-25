<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Attributes\Layout;
use Livewire\Component;

new #[Layout('layouts.client')] class extends Component
{
    use HasProgramSemester;

    /** Optional study-program filter; null = all the client's programs. */
    public ?int  $programId      = null;
    public array $programOptions = [];

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $client = $this->client();
        $this->mountSemesterContext($client?->id);

        if ($client) {
            $this->programOptions = Program::where('client_id', $client->id)
                ->orderBy('abbrev')->get(['id', 'abbrev', 'name'])
                ->map(fn ($p) => ['id' => $p->id, 'name' => "{$p->abbrev} — {$p->name}"])
                ->toArray();
        }
    }

    public function updatedAcademicYearId(): void
    {
        $this->loadProgramSemesters();
        $this->persistSemester();
    }

    public function updatedSemesterId(): void
    {
        $this->persistSemester();
    }

    public function with(): array
    {
        // The recap itself is built inside the workload-table child from these ids — passing
        // the (large, deeply nested) report array across the Livewire boundary dropped it,
        // leaving the table empty. The child owns the query so the data always arrives.
        return ['clientId' => $this->client()?->id];
    }
}; ?>

<div>
    <x-header title="Lecturer Workload" subtitle="SKS recap across study programs" separator />

    <div class="flex flex-wrap items-center gap-3 mb-4">
        <x-select wire:model.live="academicYearId" :options="$academicYearOptions"
                  placeholder="Academic Year" class="w-48" />
        <x-select wire:model.live="semesterId" :options="$semesterOptions"
                  placeholder="Semester" class="w-48" />
        <div class="w-72 shrink-0">
            <x-choices single searchable wire:model.live="programId" :options="$programOptions"
                       placeholder="— All Programs —" clearable />
        </div>
    </div>

    @if(! $semesterId)
        <x-alert title="Select a semester to view the workload recap."
                 icon="o-information-circle" class="alert-info" />
    @else
        <livewire:pages::client.data.workload.workload-table
            :client-id="$clientId"
            :program-id="$programId"
            :semester-id="$semesterId"
            :key="'wt-' . $semesterId . '-' . ($programId ?? 'all')" />
    @endif
</div>
