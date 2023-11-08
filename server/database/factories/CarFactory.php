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
            'brand' => fake()->randomElement(['Toyota', 'Honda', 'Suzuki', 'Mitsubishi', 'Daihatsu', 'Mazda', 'Nissan', 'Mercedes-Benz', 'BMW', 'Audi', 'Lexus', 'Isuzu']),
            'body_type' => fake()->randomElement(['SUV', 'Sedan', 'Hatchback', 'MPV', 'Wagon']),
            'year' => fake()->year,
            'km_min' => fake()->numberBetween(0, 100000),
            'km_max' => fake()->numberBetween(100000, 200000),
            'fuel' => fake()->randomElement(['Pertamax', 'Solar']),
            'price' => fake()->numberBetween(100000000, 200000000),
            'image' => fake()->imageUrl(),
            'description' => fake()->text,
            'condition' => fake()->randomElement(['Used', 'New']),
            'transmission' => fake()->randomElement(['Automatic', 'Manual']),
            'status' => fake()->randomElement(['Available']),
        ];
    }
}
