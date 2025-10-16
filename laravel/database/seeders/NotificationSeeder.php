<?php
declare(strict_types=1);
namespace Database\Seeders;

use App\Models\Subscription;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Subscriber;
use App\Models\PublisherList;
use App\Models\Notification;
use Faker\Factory as FakerFactory;

class NotificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = FakerFactory::create();
        $publisherListIds = PublisherList::all()->pluck('id')->toArray();
        foreach($publisherListIds as $publisherListId){
            $type = $faker->randomElement(Notification::VALID_TYPES);
            $message = $faker->text(200);
            Notification::create([
                'publisher_list_id' => $publisherListId,
                'type' => $type,
                'title' => 'Notification for Publisher List ' . $publisherListId . ' by ' . $type,
                'message' => $message
            ]);
        }
    }
}
