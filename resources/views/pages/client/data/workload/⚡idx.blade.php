<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Client;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Attributes\Layout;
use Livewire\Component;

new #[Layout('layouts.client')] class extends Component
{
    use HasProgramSemester;

    private function client(): ?Client
    {
        return Client::where('user_id', auth()->id())->first();
    }

    public function mount(): void
    {
        $this->mountSemesterContext($this->client()?->id);
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

        $report = $client
            ? app(LecturerWorkloadReport::class)->forClient($client, $this->semesterId)
            : ['programs' => [], 'rows' => []];

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
    </div>

    @if(! $semesterId)
        <x-alert title="Select a semester to view the workload recap."
                 icon="o-information-circle" class="alert-info" />
    @elseif(count($rows) === 0)
        <x-alert title="No lecturer workload found for this period."
                 icon="o-information-circle" class="alert-info" />
    @else
        <livewire:pages::client.data.workload.workload-table
            :programs="$programs" :rows="$rows" :key="'wt-' . $semesterId" />
    @endif
</div>
