<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    public const VALID_TYPES = ['in-app', 'sms', 'mail', 'push'];
    protected $table = 'notifications';
    protected $fillable = [
        'publisher_id',
        'publisher_list_id',
        'type' => 'string',
        'title' => 'string',
        'message' => 'text',
    ];
}