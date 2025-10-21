<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AuthorizedSender extends Model
{
    use HasFactory;
    protected $table = 'authorized_senders';
    protected $fillable = [
        'receiver_id',
        'sender_id',
        'subscriber_service_channel_id',
    ];

    protected $casts = [
        'receiver_id' => 'integer',
        'sender_id' => 'integer',
        'subscriber_service_channel_id' => 'integer',
    ];

    protected function receiver()
    {
        return $this->belongsTo(Subscriber::class, 'receiver_id');
    }

    protected function sender()
    {
        return $this->belongsTo(Subscriber::class, 'sender_id');
    }

    protected function subscriberServiceChannel()
    {
        return $this->belongsTo(SubscriberServiceChannel::class, 'subscriber_service_channel_id');
    }
}
