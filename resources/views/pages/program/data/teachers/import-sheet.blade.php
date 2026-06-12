<?php

use App\Exports\FetNet\TeachersTemplateExport;
use App\Jobs\FetNet\TeachersImportJob;
use App\Models\FetNet\Program;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithFileUploads;
use Mary\Traits\Toast;

new class extends Component
{
    use WithFileUploads, Toast;

    public bool  $modal      = false;
    public bool  $importing  = false;
    public mixed $importFile = null;

    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    public function getListeners(): array
    {
        return ['echo:teachers-import,.TeachersImportEvent' => 'onImportDone'];
    }

    public function onImportDone(array $event): void
    {
        $this->importing = false;
        ($event['status'] ?? '') === 'success'
            ? $this->success($event['message'], position: 'toast-top toast-center')
            : $this->error($event['message'],   position: 'toast-top toast-center');
        $this->dispatch('teacher-changed');
    }

    #[On('open-teacher-import')]
    public function open(): void
    {
        $this->reset('importFile');
        $this->modal = true;
    }

    public function downloadTemplate(): mixed
    {
        $abbrev = $this->program()?->abbrev ?? '';
        return \Maatwebsite\Excel\Facades\Excel::download(new TeachersTemplateExport($abbrev), 'teachers_template.xlsx');
    }

    public function import(): void
    {
        $this->validate(['importFile' => 'required|file|mimes:xlsx,xls|max:5120']);

        $program = $this->program();
        if (! $program) { $this->error('Program not found.', position: 'toast-top toast-center'); return; }

        $ext      = $this->importFile->getClientOriginalExtension();
        $filename = 'teachers_' . uniqid() . '.' . $ext;
        $destDir  = storage_path('app/imports/teachers');
        $destPath = $destDir . '/' . $filename;

        if (! is_dir($destDir)) mkdir($destDir, 0775, true);
        copy($this->importFile->getRealPath(), $destPath);

        TeachersImportJob::dispatch($destPath, $program->id);

        $this->reset('importFile');
        $this->modal     = false;
        $this->importing = true;
        $this->info('Import queued. You will be notified when done.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Import Teachers from Excel"
             separator class="modal-bottom" box-class="!max-w-md mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-alert title="Required: study_program, name"
                     description="study_program must match the program abbreviation. code = 3 chars (auto-generated if blank/duplicate). Optional: univ_code, employee_id, position, civil_grade, front_title, rear_title, email, phone."
                     icon="o-information-circle" class="alert-info" />
            <div class="flex justify-end">
                <x-button label="Download Template" icon="o-arrow-down-tray" class="btn-ghost btn-sm" wire:click="downloadTemplate" />
            </div>
            <x-form wire:submit="import" class="space-y-4">
                <x-file wire:model="importFile" label="Excel File (.xlsx / .xls)" accept=".xlsx,.xls" hint="Max 5MB" />
                <x-slot:actions>
                    <x-button label="Cancel" icon="o-x-circle"      wire:click="$set('modal', false)" />
                    <x-button label="Import" icon="o-arrow-up-tray" type="submit" class="btn-primary" spinner="import" />
                </x-slot:actions>
            </x-form>
        </div>
    </x-modal>
</div>
