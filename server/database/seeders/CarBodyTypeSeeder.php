<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class CarBodyTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\CarBodyType::factory(5)->sequence(
            [
                'name' => 'SUV',
            ],
            [
                'name' => 'Sedan',
            ],
            [
                'name' => 'Hatchback',
            ],
            [
                'name' => 'MPV',
            ],
            [
                'name' => 'Wagon',
            ],
        )->create();
    }
}
