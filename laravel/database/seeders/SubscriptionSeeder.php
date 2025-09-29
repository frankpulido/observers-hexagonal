<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Subscriber;
use App\Models\PublisherList;
use App\Models\Subscription;

class SubscriptionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $subscribers = Subscriber::all();
        $publisherLists = PublisherList::all()->pluck('id')->toArray();
        foreach ($subscribers as $subscriber) {
            $subscription = rand(1, count($publisherLists));
            Subscription::create([
                'subscriber_id' => $subscriber->id,
                'publisher_list_id' => $subscription,
            ]);
        }
    }
}
