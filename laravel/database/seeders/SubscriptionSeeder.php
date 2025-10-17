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
        $publisherLists = PublisherList::all()->pluck('id')->toArray();
        foreach ($subscribers as $subscriber) {
            $subscription = rand(1, count($publisherLists));
            // get an active subscriber channel
            Subscription::create([
                'subscriber_id' => $subscriber->id,
                'publisher_list_id' => $subscription,
                // get the first active channel for the subscriber - fix query below
                //'service_channel_id' => DB::subscriber_service_channels($subscriber->id)[0]->id,
            ]);
        }
    }
}
