<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Subscriber;

class SubscriberSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i = 1; $i <= 10; $i++) {
            $user = User::factory()->create();
            /*
            $subscriber = new Subscriber();
            $subscriber->user_id = $user->id;
            $subscriber->is_active = true;
            $subscriber->save();
            */

            // Activate a channel for the subscriber
        }
    }
}
