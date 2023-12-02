<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Cart>
 */
class CartFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $sampleUser = User::where('email', 'user@gmail.com')->get()->pluck('id')->toArray();

        return [
            'user_id' => $this->faker->randomElement($sampleUser),
            'car_id' => $this->faker->numberBetween(1, 10),
            'quantity' => $this->faker->numberBetween(1, 10),
            'subtotal' => $this->faker->randomNumber(),
        ];
    }
}
