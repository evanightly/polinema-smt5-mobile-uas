<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class CarBrandSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\CarBrand::factory(10)->sequence(
            [
                'name' => 'Toyota',
            ],
            [
                'name' => 'Honda',
            ],
            [
                'name' => 'Daihatsu',
            ],
            [
                'name' => 'Mitsubishi',
            ],
            [
                'name' => 'Suzuki',
            ],
            [
                'name' => 'Nissan',
            ],
            [
                'name' => 'Mazda',
            ],
            [
                'name' => 'Isuzu',
            ],
            [
                'name' => 'Mercedes-Benz',
            ],
            [
                'name' => 'BMW',
            ],
        )->create();
    }
}
