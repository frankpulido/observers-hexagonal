<?php
declare(strict_types=1);
namespace App\Observers;

use App\Models\ServiceChannel;
use App\Models\Subscriber;
use Illuminate\Container\Attributes\DB;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Events\ShouldHandleEventsAfterCommit;

class ServiceChannelObserver implements ShouldHandleEventsAfterCommit
{
    public function created(ServiceChannel $serviceChannel): void
    {
        foreach (Subscriber::all() as $subscriber) {
            ServiceChannel::create([
                'subscriber_id' => $subscriber->id,
                'service_channel_id' => $serviceChannel->id,
            ]);
        }
    }
}
