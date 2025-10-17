<?php
declare(strict_types=1);
namespace App\Observers;

use App\Models\SubscriberServiceChannel;
use App\Models\Subscriber;
use App\Models\ServiceChannel;
use Illuminate\Container\Attributes\DB;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Events\ShouldHandleEventsAfterCommit;

class SubscriberObserver
{
    public function created(Subscriber $subscriber): void
    {
        foreach (ServiceChannel::all() as $serviceChannel) {
            SubscriberServiceChannel::create([
                'subscriber_id' => $subscriber->id,
                'service_channel_id' => $serviceChannel->id,
                'service_channel_username' => null,  // User provides it later
                'verification_token' => null,
                'verified_at' => null,
                'is_active' => false,
            ]);
        }
    }
}
