<?php

use App\Models\FetNet\Client;
use App\Models\User;
use Livewire\Attributes\On;
use Livewire\Component;
use Mary\Traits\Toast;
use Spatie\Permission\Models\Role;

/**
 * Create/edit sheet for a system User. Manages name, email, SSO/NIP, optional password,
 * a single role (via Spatie), and client assignment. Emits 'user-changed' on save.
 */
new class extends Component
{
    use Toast;

    public bool   $modal      = false;
    public bool   $isCreating = false;
    public ?int   $userId     = null;
    public string $formName   = '';
    public string $formEmail  = '';
    public string $formSso    = '';
    public string $formPassword = '';
    public ?int   $formRoleId   = null;
    public ?int   $formClientId = null;

    public array $rolesOptions   = [];
    public array $clientsOptions = [];

    /** Load role + client picker options once. */
    public function mount(): void
    {
        $this->rolesOptions = Role::all(['id', 'name'])
            ->map(fn($r) => ['id' => $r->id, 'name' => $r->name])->toArray();

        $this->clientsOptions = Client::with('university')->get()
            ->map(fn($c) => ['id' => $c->id, 'name' => $c->university?->name ?? "Client #{$c->id}"])
            ->toArray();
    }

    /** Open the sheet for a new user (blank form). */
    #[On('open-user-create')]
    public function openCreate(): void
    {
        $this->isCreating = true;
        $this->userId = null;
        $this->formName = ''; $this->formEmail = ''; $this->formSso = '';
        $this->formPassword = ''; $this->formRoleId = null; $this->formClientId = null;
        $this->modal = true;
    }

    /** Open the sheet prefilled from an existing user (password left blank). */
    #[On('open-user-edit')]
    public function openEdit(int $id): void
    {
        $user = User::with('roles')->findOrFail($id);
        $this->isCreating = false;
        $this->userId = $id;
        $this->formName     = $user->name;
        $this->formEmail    = $user->email ?? '';
        $this->formSso      = $user->sso ?? '';
        $this->formPassword = '';
        $this->formRoleId   = $user->roles->first()?->id;
        $this->formClientId = $user->client_id;
        $this->modal = true;
    }

    /**
     * Validate and create or update the user (hashing a new password only when given),
     * sync the chosen role (or clear roles), then emit 'user-changed'.
     */
    public function saveUser(): void
    {
        $uniqueEmail = $this->userId ? "unique:users,email,{$this->userId}" : 'unique:users,email';
        $uniqueSso   = $this->userId ? "unique:users,sso,{$this->userId}"   : 'unique:users,sso';

        $this->validate([
            'formName'     => 'required|string|max:255',
            'formEmail'    => "nullable|email|max:255|{$uniqueEmail}",
            'formSso'      => "nullable|string|max:50|{$uniqueSso}",
            'formPassword' => 'nullable|string|min:8',
            'formRoleId'   => 'nullable|exists:roles,id',
            'formClientId' => 'nullable|exists:fetnet_client,id',
        ]);

        if ($this->isCreating) {
            $user = User::create([
                'name'      => $this->formName,
                'email'     => $this->formEmail    ?: null,
                'sso'       => $this->formSso      ?: null,
                'password'  => $this->formPassword ? bcrypt($this->formPassword) : null,
                'client_id' => $this->formClientId,
            ]);
        } else {
            $user = User::findOrFail($this->userId);
            $user->name      = $this->formName;
            $user->email     = $this->formEmail    ?: null;
            $user->sso       = $this->formSso      ?: null;
            $user->client_id = $this->formClientId;
            if ($this->formPassword !== '') $user->password = bcrypt($this->formPassword);
            $user->save();
        }

        if ($this->formRoleId) {
            $role = Role::findOrFail($this->formRoleId);
            $user->syncRoles($role->name);
        } else {
            $user->syncRoles([]);
        }

        $this->success(
            $this->isCreating ? 'User created successfully.' : 'User updated successfully.',
            position: 'toast-top toast-center'
        );
        $this->modal = false;
        $this->dispatch('user-changed');
    }
}; ?>

<div>
    <x-modal wire:model="modal" separator class="modal-bottom"
             box-class="!max-w-md mx-auto !rounded-t-2xl !mb-14">
        <x-slot:title>{{ $isCreating ? 'New User' : 'Edit User' }}</x-slot:title>

        <x-form wire:submit="saveUser" class="space-y-4">
            <input type="text" class="w-0 h-0 opacity-0 absolute pointer-events-none" autofocus />
            <x-input label="Name" wire:model="formName" required />
            <div class="grid grid-cols-2 gap-3">
                <x-input label="Email"     wire:model="formEmail" type="email" />
                <x-input label="SSO / NIP" wire:model="formSso" />
            </div>
            <x-input label="Password" wire:model="formPassword" type="password"
                     hint="{{ $isCreating ? 'Leave blank for no password (SSO login only)' : 'Leave blank to keep current password' }}" />
            <div class="grid grid-cols-2 gap-3">
                <x-choices label="Role"   single searchable wire:model="formRoleId"   :options="$rolesOptions"   placeholder="No role" />
                <x-choices label="Client" single searchable wire:model="formClientId" :options="$clientsOptions" placeholder="No client (super-admin)" />
            </div>
            <x-slot:actions>
                <x-button label="Cancel" icon="o-x-circle"     wire:click="$set('modal', false)" />
                <x-button label="Save"   icon="o-check-circle" type="submit" class="btn-primary" spinner="saveUser" />
            </x-slot:actions>
        </x-form>
    </x-modal>
</div>
