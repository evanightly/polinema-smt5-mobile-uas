<?php

namespace Database\Factories;

use App\Models\Admin;
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
        $sampleAdmins = Admin::all()->pluck('id')->splice(0, $samplePortion);

        return [
            'user_id' => fake()->randomElement($sampleUsers),
            'payment_method' => fake()->randomElement(['Cash', 'CreditCard', 'DebitCard']),
            'payment_proof' => fake()->imageUrl(),
            'payment_date' => fake()->date(),
            'total' => fake()->numberBetween(100000000, 200000000),
            'status' => fake()->randomElement(['Pending', 'Finished', 'Rejected', 'Verified']),
            'verified_by' => fake()->randomElement($sampleAdmins),
            'verified_at' => fake()->date(),
            'deliver_address' => fake()->address(),
        ];
    }
}
