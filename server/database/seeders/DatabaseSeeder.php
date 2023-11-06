<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use Faker\Core\Uuid;
use Illuminate\Database\Seeder;
use Ramsey\Uuid\Uuid as UuidUuid;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        \App\Models\Admin::factory(10)->create();

        \App\Models\Admin::factory()->create([
            'id' => UuidUuid::uuid4(),
            'name' => 'Evan Henderson',
            'email' => 'evan@gmail.com',
            'password' => 'password',
            'isSuperAdmin' => true,
        ]);
    }
}
