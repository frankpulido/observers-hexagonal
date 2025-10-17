<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;


class SubscriberServiceChannel extends Model
{
    use HasApiTokens;
    use HasFactory;
    protected $table = 'subscriber_service_channels';
    protected $fillable = [
        'subscriber_id',
        'service_channel_id',
        'service_channel_username',
        'verification_token',
        'verified_at',
        'is_active',
    ];

    protected $casts = [
        'subscriber_id' => 'integer',
        'service_channel_id' => 'integer',
        'service_channel_username' => 'string',
        'verification_token' => 'string',
        'verified_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($subscriberServiceChannel) {
            $subscriberServiceChannel->is_active = false;
        });
    }

    public function subscriber()
    {
        return $this->belongsTo(Subscriber::class);
    }

    public function serviceChannel()
    {
        return $this->belongsTo(ServiceChannel::class);
    }
}
