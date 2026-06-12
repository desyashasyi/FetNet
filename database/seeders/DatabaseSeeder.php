<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            RolesAndPermissionsSeeder::class,
            ClientLevelSeeder::class,
        ]);

        // Super-admin awal. Password hanya di-set saat user pertama kali dibuat
        // supaya perubahan password di UI tidak ter-reset tiap container restart.
        $superAdmin = User::firstOrCreate(
            ['sso' => '197608272009121001'],
            [
                'name'     => 'Dedi Wahyudi',
                'email'    => 'deewahyu@upi.edu',
                'password' => 'Ddw9889##',
            ]
        );

        $superAdmin->syncRoles('super-admin');
    }
}
