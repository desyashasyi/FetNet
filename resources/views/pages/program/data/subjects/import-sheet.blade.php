<?php

use App\Exports\FetNet\SubjectsTemplateExport;
use App\Imports\FetNet\SubjectImport;
use App\Models\FetNet\Program;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithFileUploads;
use Maatwebsite\Excel\Facades\Excel;
use Mary\Traits\Toast;

/**
 * Subject import sheet: upload an .xlsx/.xls and import it synchronously via SubjectImport,
 * then toast the imported/skipped summary and refresh the listing/options in the same
 * request. Runs inline (not queued) so the success alert + refresh do not depend on a
 * realtime broadcast being delivered. Also serves a downloadable template.
 */
new class extends Component
{
    use WithFileUploads, Toast;

    public bool  $modal      = false;
    public mixed $importFile = null;

    /** The signed-in user's program (import target). */
    private function program(): ?Program
    {
        return Program::where('user_id', auth()->id())->first();
    }

    /** Open the import sheet (clears any previous file). */
    #[On('open-subject-import')]
    public function open(): void
    {
        $this->reset('importFile');
        $this->modal = true;
    }

    /** Download the blank subjects import template. */
    public function downloadTemplate(): mixed
    {
        return \Maatwebsite\Excel\Facades\Excel::download(new SubjectsTemplateExport(), 'subjects_template.xlsx');
    }

    /** Validate the upload, import it synchronously, then toast the result and refresh. */
    public function import(): void
    {
        $this->validate(['importFile' => 'required|file|mimes:xlsx,xls|max:5120']);

        $program = $this->program();
        if (! $program) { $this->error('Program not found.', position: 'toast-top toast-center'); return; }

        try {
            $importer = new SubjectImport($program->id);
            Excel::import($importer, $this->importFile->getRealPath());
        } catch (\Throwable $e) {
            $this->reset('importFile');
            $this->error('Import failed: ' . $e->getMessage(), position: 'toast-top toast-center');
            return;
        }

        $this->reset('importFile');
        $this->modal = false;
        $this->success(
            "Import done: {$importer->imported} imported, {$importer->skipped} skipped.",
            position: 'toast-top toast-center',
        );
        $this->dispatch('subject-changed');
        $this->dispatch('refresh-subject-options');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Import Subjects from Excel"
             separator class="modal-bottom" box-class="!max-w-md mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-alert title="Required: code, name"
                     description="Optional: credit (default 2), semester (1–8), curriculum_year, specialization (code), type (code)."
                     icon="o-information-circle" class="alert-info" />
            <div class="flex justify-end">
                <x-button label="Download Template" icon="o-arrow-down-tray" class="btn-ghost btn-sm" wire:click="downloadTemplate" />
            </div>
            <x-form wire:submit="import" class="space-y-4">
                <x-file wire:model="importFile" label="Excel File (.xlsx / .xls)" accept=".xlsx,.xls" hint="Max 5MB" />
                <x-slot:actions>
                    <x-button label="Cancel" icon="o-x-circle" wire:click="$set('modal', false)" />
                    <x-button label="Import" icon="o-arrow-up-tray" type="submit" class="btn-primary" spinner="import" />
                </x-slot:actions>
            </x-form>
        </div>
    </x-modal>
</div>
