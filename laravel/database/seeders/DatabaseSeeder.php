<?php
declare(strict_types=1);
namespace Database\Seeders;

use App\Models\ServiceChannel;
use App\Models\User;
use Dflydev\DotAccessData\Data;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::create([
            'username' => 'janedoe',
            //'email' => 'frankpulido@me.com',
            //'mobile' => '653343353',
            //'role' => 'publisher',
            'password' => 'password',
        ]);

        User::create([
            'username' => 'johndoe',
            //'email' => 'johndoe@mail.com',
            //'mobile' => '654123456',
            //'role' => 'publisher',
            'password' => 'password',
        ]);
        
        //User::factory()->count(10)->create();

        ServiceChannel::create(['name' => 'alexa']);
        ServiceChannel::create(['name' => 'discord']);
        ServiceChannel::create(['name' => 'home_assistant']);
        ServiceChannel::create(['name' => 'slack']);

        $this->call([
            PublisherSeeder::class,
            SubscriberSeeder::class,
            PublisherListSeeder::class,
            SubscriptionSeeder::class,
            NotificationSeeder::class,
        ]);
    }
}
