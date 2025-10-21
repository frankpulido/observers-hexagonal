<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use App\Models\Subscriber;

class AuthorizedSender extends Model
{
    use HasFactory;
    use HasApiTokens;
    protected $table = 'authorized_senders';
    protected $fillable = [
        'receiver_id',
        'sender_id',
        'service_channel_id',
    ];

    protected $casts = [
        'receiver_id' => 'integer',
        'sender_id' => 'integer',
        'service_channel_id' => 'integer',
    ];

    protected function receiver()
    {
        return $this->belongsTo(Subscriber::class, 'receiver_id');
    }

    protected function sender()
    {
        return $this->belongsTo(Subscriber::class, 'sender_id');
    }

    protected function serviceChannel()
    {
        return $this->belongsTo(ServiceChannel::class);
    }
}
