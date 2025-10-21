<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DirectMessageLog extends Model
{
    use HasFactory;
    protected $table = 'direct_message_logs';

    protected $fillable = [
        'receiver_id',
        'sender_id',
        'sent_at',
        'status',
    ];

    protected $casts = [
        'receiver_id' => 'integer',
        'sender_id' => 'integer',
        'sent_at' => 'datetime',
        'status' => 'boolean',
    ];

    public function receiver()
    {
        return $this->belongsTo(Subscriber::class, 'receiver_id');
    }

    public function sender()
    {
        return $this->belongsTo(Subscriber::class, 'sender_id');
    }
}
