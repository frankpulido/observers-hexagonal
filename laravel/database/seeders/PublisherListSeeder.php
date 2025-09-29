<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\PublisherList;

class PublisherListSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $lists = [
            'Tech News',
            'Daily Updates',
            'Weekly Digest',
            'Promotions',
            'Event Announcements',
        ];

        foreach ($lists as $listName) {
            PublisherList::create([
                'publisher_id' => 1,
                'name' => $listName
            ]);
        }
    }
}
