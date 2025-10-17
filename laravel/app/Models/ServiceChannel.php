<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

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
}
