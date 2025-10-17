<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Attributes\ObservedBy;
use \App\Observers\ServiceChannelObserver;
use Laravel\Sanctum\HasApiTokens;

#[ObservedBy(ServiceChannelObserver::class)]
class ServiceChannel extends Model
{
    use HasFactory;
    protected $table = 'service_channels';
    protected $fillable = [
        'name'
    ];

    protected $casts = [
        'name' => 'string',
    ];

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }

    public function subscriberServiceChannels()
    {
        return $this->hasMany(SubscriberServiceChannel::class);
    }
}
