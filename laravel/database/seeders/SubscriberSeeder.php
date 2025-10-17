<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Subscriber;
use App\Models\SubscriberServiceChannel;

class SubscriberSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i = 1; $i <= 10; $i++) {
            $user = User::factory()->create();
        }
        $subscriber_service_channels = SubscriberServiceChannel::all();
        foreach ($subscriber_service_channels as $ssc) {
            $ssc->is_active = random_int(0, 1) == 1 ? true : false;  // random boolean
            $ssc->save();
        }
    }
}
