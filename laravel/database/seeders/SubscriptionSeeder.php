<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Subscriber;
use App\Models\PublisherList;
use App\Models\Subscription;
use Illuminate\Support\Facades\DB;

class SubscriptionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $subscribers = Subscriber::where('is_active', true)->get();
        $publisherListsIds = PublisherList::all()->pluck('id');
        foreach ($subscribers as $subscriber) {
            $activeChannel = $subscriber->subscriberServiceChannels()
                ->where('is_active', true)
                ->first();

            if ($activeChannel) {
                Subscription::create([
                    'subscriber_id' => $subscriber->id,
                    'publisher_list_id' => $publisherListsIds->random(),
                    'service_channel_id' => $activeChannel->service_channel_id,
                ]);
            }
        }
    }
}
