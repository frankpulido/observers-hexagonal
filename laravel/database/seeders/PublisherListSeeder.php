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
        $lists_public = [
            'Tech News',
            'Daily Updates',
            'Weekly Digest',
            'Promotions',
            'Event Announcements',
        ];

        $lists_private = [
            'Private List 1',
            'Private List 2',
            'Private List 3',
            'Private List 4',
            'Private List 5',
        ];

        foreach ($lists_public as $listName) {
            PublisherList::create([
                'publisher_id' => 1,
                'name' => $listName
            ]);
        }
        
        foreach ($lists_private as $listName) {
            PublisherList::create([
                'publisher_id' => 2,
                'name' => $listName,
                'is_private' => true,
            ]);
        }

    }
}
