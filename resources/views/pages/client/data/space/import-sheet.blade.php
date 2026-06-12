<?php

use App\Exports\FetNet\SpaceTemplateExport;
use App\Jobs\FetNet\SpaceImportJob;
use App\Models\FetNet\Client;
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

    public function getListeners(): array
    {
        return ['echo:space-import,.SpaceImportEvent' => 'onImportDone'];
    }

    public function onImportDone(array $event): void
    {
        $this->importing = false;
        ($event['status'] ?? '') === 'success'
            ? $this->success($event['message'], position: 'toast-top toast-center')
            : $this->error($event['message'],   position: 'toast-top toast-center');
        $this->dispatch('space-changed');
        $this->dispatch('options-reload');
    }

    #[On('open-import')]
    public function open(): void
    {
        $this->reset('importFile');
        $this->modal = true;
    }

    public function downloadTemplate(): mixed
    {
        return \Maatwebsite\Excel\Facades\Excel::download(
            new SpaceTemplateExport(),
            'space_template.xlsx'
        );
    }

    public function import(): void
    {
        $this->validate(['importFile' => 'required|file|mimes:xlsx,xls|max:5120']);

        $client = Client::where('user_id', auth()->id())->first();
        if (! $client) {
            $this->error('Client not found.', position: 'toast-top toast-center');
            return;
        }

        $ext      = $this->importFile->getClientOriginalExtension();
        $filename = 'space_' . uniqid() . '.' . $ext;
        $destDir  = storage_path('app/imports/space');
        $destPath = $destDir . '/' . $filename;

        if (! is_dir($destDir)) mkdir($destDir, 0775, true);
        copy($this->importFile->getRealPath(), $destPath);

        SpaceImportJob::dispatch($destPath, $client->id);

        $this->reset('importFile');
        $this->modal     = false;
        $this->importing = true;
        $this->info('Import queued. You will be notified when done.', position: 'toast-top toast-center');
    }
}; ?>

<div>
    <x-modal wire:model="modal" title="Import Spaces from Excel"
             separator class="modal-bottom" box-class="!max-w-md mx-auto !rounded-t-2xl !mb-14">
        <div class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-alert title="Required: name"
                     description="type_code must match a space type code (e.g. LAB, CLS). building_code must match an existing building code. Optional: code, floor, capacity."
                     icon="o-information-circle" class="alert-info" />
            <div class="flex justify-end">
                <x-button label="Download Template" icon="o-arrow-down-tray" class="btn-ghost btn-sm"
                          wire:click="downloadTemplate" />
            </div>
            <x-form wire:submit="import" class="space-y-4">
                <x-file wire:model="importFile" label="Excel File (.xlsx / .xls)"
                        accept=".xlsx,.xls" hint="Max 5MB" />
                <x-slot:actions>
                    <x-button label="Cancel" icon="o-x-circle"      wire:click="$set('modal', false)" />
                    <x-button label="Import" icon="o-arrow-up-tray" type="submit" class="btn-primary" spinner="import" />
                </x-slot:actions>
            </x-form>
        </div>
    </x-modal>
</div>
