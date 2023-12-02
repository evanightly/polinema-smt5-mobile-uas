<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Car>
 */
class CarFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->lastName(),
            'brand_id' => fake()->numberBetween(1, 10),
            'body_type_id' => fake()->numberBetween(1, 5),
            'year' => fake()->year,
            'mileage' => fake()->numberBetween(10000, 200000),
            'fuel_id' => fake()->numberBetween(1, 8),
            'price' => fake()->numberBetween(15000, 100000),
            'image' => fake()->imageUrl(),
            'description' => fake()->text,
            'condition' => fake()->randomElement(['Used', 'New']),
            'transmission' => fake()->randomElement(['Automatic', 'Manual']),
            'stock' => fake()->numberBetween(0, 10)
        ];
    }
}
