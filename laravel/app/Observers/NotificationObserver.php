<?php
declare(strict_types=1);
namespace App\Observers;

use App\Models\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Events\ShouldHandleEventsAfterCommit;


class NotificationObserver implements ShouldHandleEventsAfterCommit
{
    public function created(Notification $notification): void
    {
        // Logic to handle after a notification is created
    }
}
