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

        // Super-admin awal
        $superAdmin = User::firstOrCreate(
            ['sso' => '197608272009121001'],
            [
                'name'     => 'Dedi Wahyudi',
                'email'    => 'deewahyu@upi.edu',
                'password' => 'Ddw9889##',
            ]
        );

        // Pastikan password ter-set walau user sudah ada sebelumnya.
        $superAdmin->forceFill(['password' => 'Ddw9889##'])->save();

        $superAdmin->syncRoles('super-admin');
    }
}
