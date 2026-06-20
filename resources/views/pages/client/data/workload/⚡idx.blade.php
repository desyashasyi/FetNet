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
        $client = $this->client();
        $report = ['programs' => [], 'rows' => []];

        if ($client) {
            $service = app(LecturerWorkloadReport::class);

            // A selected program scopes the recap to everyone teaching in it (guests
            // included); otherwise show the whole client's lecturers.
            $program = $this->programId
                ? Program::where('client_id', $client->id)->find($this->programId)
                : null;

            $report = $program
                ? $service->forProgram($program, $this->semesterId)
                : $service->forClient($client, $this->semesterId);
        }

        return [
            'programs' => $report['programs'],
            'rows'     => $report['rows'],
        ];
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
    @elseif(count($rows) === 0)
        <x-alert title="No lecturer workload found for this period."
                 icon="o-information-circle" class="alert-info" />
    @else
        <livewire:pages::client.data.workload.workload-table
            :programs="$programs" :rows="$rows" :key="'wt-' . $semesterId . '-' . ($programId ?? 'all')" />
    @endif
</div>
