<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Ramsey\Uuid\Uuid;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\Admin::factory(15)->create();

        \App\Models\Admin::factory()->create([
            'id' => Uuid::uuid4(),
            'name' => 'Evan Henderson',
            'email' => 'evan@gmail.com',
            'password' => Hash::make('admin'),
            'is_super_admin' => true,
        ]);
    }
}
