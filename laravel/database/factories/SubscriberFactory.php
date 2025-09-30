<?php
declare(strict_types=1);
namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Subscriber;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Subscriber>
 */
class SubscriberFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'first_name' => $this->faker->firstName(),
            'last_name' => $this->faker->lastName(),
            'subscriber_email' => $this->faker->unique()->safeEmail(),
            'subscriber_mobile' => $this->faker->unique()->numberBetween(600000000, 699999999),
            'date_of_birth' => $this->faker->date(),
            'gender' => $this->faker->randomElement(Subscriber::VALID_GENDERS),
            'city' => $this->faker->randomElement(['Barcelona', 'Madrid', 'Bilbao', 'Valencia', 'Sevilla']),
            'occupation' => $this->faker->randomElement(Subscriber::VALID_OCCUPATIONS),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
