<?php

use App\Livewire\Concerns\HasProgramSemester;
use App\Models\FetNet\Program;
use App\Services\FetNet\LecturerWorkloadReport;
use Livewire\Attributes\Layout;
use Livewire\Component;

/**
 * Program lecturer-workload page: SKS recap across study programs for everyone teaching
 * in this program during the chosen period (guests included), via LecturerWorkloadReport
 * ::forProgram. Uses the HasProgramSemester trait for the academic-year/semester pickers
 * and renders the shared workload-table component.
 */
new #[Layout('layouts.program')] class extends Component
{
    use HasProgramSemester;

    /** The signed-in user's program. */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Seed the semester context (academic years + active semester) for the program's client. */
    public function mount(): void
    {
        $program = $this->program();
        if ($program) {
            $this->mountSemesterContext($program->client_id);
        }
    }

    /** Reload the semester options for the chosen academic year and persist the choice. */
    public function updatedAcademicYearId(): void
    {
        $this->loadProgramSemesters();
        $this->persistSemester();
    }

    /** Persist the chosen semester to the session context. */
    public function updatedSemesterId(): void
    {
        $this->persistSemester();
    }

    /** Build the cross-program workload recap (programs + rows) for the chosen semester. */
    public function with(): array
    {
        $program = $this->program();

        $report = $program
            ? app(LecturerWorkloadReport::class)->forProgram($program, $this->semesterId)
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
