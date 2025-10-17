<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use App\Models\ServiceChannel;

class Subscriber extends Model
{
    use HasFactory;
    //public const VALID_GENDERS = ['male', 'female', 'other'];
    //public const VALID_OCCUPATIONS = ['student', 'employed', 'unemployed', 'retired', 'other'];
    protected $table = 'subscribers';
    protected $fillable = [
        'user_id',
        //'subscriber_channels',
        //'first_name',
        //'last_name',
        //'subscriber_email',
        //'subscriber_mobile',
        //'date_of_birth',
        //'gender',
        //'city',
        //'occupation',
        'is_active',
    ];

    protected $casts = [
        'user_id' => 'integer',
        //'subscriber_channels' => 'array',
        //'first_name' => 'string',
        //'last_name' => 'string',
        //'subscriber_email' => 'string',
        //'subscriber_mobile' => 'integer',
        //'date_of_birth' => 'date',
        //'gender' => 'string',
        //'city' => 'string',
        //'occupation' => 'string',
        'is_active' => 'boolean',
    ];

    /*
    protected static function boot()
    {
        parent::boot();
        static::creating(function ($subscriber) {
            $subscriber->subscriber_channels = [];
            $keys = ServiceChannel::all()->pluck('name')->toArray();
            foreach ($keys as $key) {
                $subscriber->subscriber_channels[$key] = false;
            }
            $subscriber->is_active = false;
        });
    }
    */

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }
}
