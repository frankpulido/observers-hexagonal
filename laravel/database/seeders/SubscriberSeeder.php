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
        $users = User::where('role', 'subscriber')->get()->pluck('id')->toArray();
        foreach ($users as $user) {
            Subscriber::factory()->create([
                'user_id' => $user,
            ]);
        }
    }
}
