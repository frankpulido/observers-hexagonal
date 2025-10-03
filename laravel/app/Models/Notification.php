<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Attributes\ObservedBy;
use \App\Observers\NotificationObserver;

#[ObservedBy(NotificationObserver::class)]
class Notification extends Model
{
    use HasFactory;
    public const VALID_TYPES = ['in-app', 'sms', 'mail', 'push'];
    protected $table = 'notifications';
    protected $fillable = [
        'publisher_list_id',
        'type' => 'string',
        'title' => 'string',
        'message' => 'text',
    ];
}