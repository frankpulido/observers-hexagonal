<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PublisherList extends Model
{
    protected $table = 'publisher_lists';
    protected $fillable = [
        'publisher_id',
        'name',
        'description',
        'is_active',
    ];

    protected $casts = [
        'name' => 'string',
        'description' => 'string',
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
