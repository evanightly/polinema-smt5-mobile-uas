<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

// use Faker\Core\Uuid;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            AdminSeeder::class,
            CarBrandSeeder::class,
            CarBodyTypeSeeder::class,
            CarFuelSeeder::class,
            CarSeeder::class,
            TransactionSeeder::class,
        ]);
    }
}
