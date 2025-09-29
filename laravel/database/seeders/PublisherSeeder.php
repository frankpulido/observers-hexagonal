<?php
declare(strict_types=1);
namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Publisher;

class PublisherSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Publisher::create([
            'user_id' => 1,
            'name' => 'Tech Publishers Inc.',
            'cif' => 'C123456789',
            'address' => '123 Tech Street, Silicon Valley, BCN',
            'city' => 'Barcelona',
            'postal_code' => '08001',
            'is_active' => true,
        ]);
    }
}
