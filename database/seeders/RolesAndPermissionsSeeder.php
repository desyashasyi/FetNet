<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

class RolesAndPermissionsSeeder extends Seeder
{
    public function run(): void
    {
        // Reset cached roles & permissions
        app()[PermissionRegistrar::class]->forgetCachedPermissions();

        // ── Roles ─────────────────────────────────────────────────────────────
        // super-admin : akses penuh via Gate::before (lihat AppServiceProvider)
        // client      : kelola data semua program studi
        // program     : akses terbatas per program studi
        // operator    : per-program, hanya akses timetable yang sudah compiled

        Role::firstOrCreate(['name' => 'super-admin']);
        Role::firstOrCreate(['name' => 'client']);
        Role::firstOrCreate(['name' => 'program']);
        Role::firstOrCreate(['name' => 'operator']);
    }
}
