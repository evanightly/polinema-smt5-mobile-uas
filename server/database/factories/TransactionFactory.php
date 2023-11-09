<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Transaction>
 */
class TransactionFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $samplePortion = 5;
        $sampleUsers = User::all()->pluck('id')->splice(0, $samplePortion);

        return [
            'user_id' => fake()->randomElement($sampleUsers),
            'car_id' => fake()->numberBetween(1, 10),
            'payment_method' => fake()->randomElement(['Cash', 'Credit Card', 'Debit Card']),
            'payment_proof' => fake()->imageUrl(),
            'payment_date' => fake()->date(),
            'payment_amount' => fake()->numberBetween(100000000, 200000000),
            'payment_status' => fake()->randomElement(['Pending', 'Success', 'Failed']),
        ];
    }
}
