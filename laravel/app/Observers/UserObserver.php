<?php
declare(strict_types=1);
namespace App\Observers;

use App\Models\User;
use App\Models\Subscriber;
use Illuminate\Container\Attributes\DB;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Events\ShouldHandleEventsAfterCommit;


class UserObserver implements ShouldHandleEventsAfterCommit
{
    public function created(User $user): void
    {
        // Logic to handle after a user is created
        Subscriber::create([
            'user_id' => $user->id,
        ]);
    }
}
