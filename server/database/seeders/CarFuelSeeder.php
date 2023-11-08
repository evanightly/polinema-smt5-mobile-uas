<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CarFuelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\CarFuel::factory()->count(8)->sequence(
            [
                'name' => 'Pertamax',
            ],
            [
                'name' => 'Pertamax Turbo',
            ],
            [
                'name' => 'Pertamax Racing',
            ],
            [
                'name' => 'Pertalite',
            ],
            [
                'name' => 'Premium',
            ],
            [
                'name' => 'Pertamina Dex',
            ],
            [
                'name' => 'Dexlite',
            ],
            [
                'name' => 'Solar',
            ],
        )->create();
    }
}
