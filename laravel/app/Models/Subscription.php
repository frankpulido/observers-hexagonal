<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subscription extends Model
{
    use HasFactory;
    protected $table = 'subscriptions';
    protected $fillable = [
        'subscriber_id',
        'publisher_list_id',
    ];

    protected $casts = [
        'subscriber_id' => 'integer',
        'publisher_list_id' => 'integer',
    ];

    public function subscriber()
    {
        return $this->belongsTo(Subscriber::class);
    }

    public function publisherList()
    {
        return $this->belongsTo(PublisherList::class);
    }
}
