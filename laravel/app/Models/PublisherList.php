<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;

class PublisherList extends Model
{
    use HasFactory;
    protected $table = 'publisher_lists';
    protected $fillable = [
        'publisher_id',
        'name',
        'description',
        'is_private',
        'is_active',
    ];

    protected $casts = [
        'name' => 'string',
        'description' => 'string',
        'is_private' => 'boolean',
        'is_active' => 'boolean',
    ];

    public function publisher()
    {
        return $this->belongsTo(Publisher::class);
    }

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }
}
