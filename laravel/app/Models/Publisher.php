<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Publisher extends Model
{
    use HasFactory;
    protected $table = 'publishers';
    protected $fillable = [
        'user_id',
        'name',
        'cif',
        'address',
        'city',
        'postal_code',
        'max_private_subscribers_plan',
        'is_active',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'name' => 'string',
        'cif' => 'string',
        'address' => 'string',
        'city' => 'string',
        'postal_code' => 'string',
        'max_private_subscribers_plan' => 'integer',
        'is_active' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function publisherLists()
    {
        return $this->hasMany(PublisherList::class);
    }
}
