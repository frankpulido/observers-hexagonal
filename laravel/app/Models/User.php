<?php
declare(strict_types=1);
namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Casts\Attribute;

class User extends Authenticatable
{
    public const VALID_ROLES = ['superadmin', 'admin', 'publisher', 'subscriber'];
    protected $table = 'users';
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'username',
        'password',
        'email',
        'mobile',
        'is_superadmin',
        'is_admin',
        'is_publisher',
        'is_subscriber',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_superadmin' => 'boolean',
            'is_admin' => 'boolean',
            'is_publisher' => 'boolean',
            'is_subscriber' => 'boolean',
        ];
    }


    public function username(): Attribute
    {
        return Attribute::make(
            set: fn ($value) => strtolower(str_replace(' ', '', trim($value)))
        );
    }

    public function email(): Attribute
    {
        return Attribute::make(
            set: fn ($value) => strtolower(str_replace(' ', '', trim($value)))
        );
    }
    
    public function subscriber()
    {
        return $this->hasOne(Subscriber::class);
    }

    public function publisher()
    {
        return $this->hasOne(Publisher::class);
    }

    public function subscriptions()
    {
        return $this->hasManyThrough(Subscription::class, Subscriber::class);
    }

    public function serviceChannels()
    {
        return $this->hasManyThrough(ServiceChannel::class, Subscription::class);
    }
}
