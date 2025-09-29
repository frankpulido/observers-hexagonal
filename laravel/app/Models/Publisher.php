<?php
declare(strict_types=1);
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Publisher extends Model
{
    protected $table = 'publishers';
    protected $fillable = [
        'user_id',
        'name',
        'cif',
        'address',
        'city',
        'postal_code',
        'is_active',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'name' => 'string',
        'cif' => 'string',
        'address' => 'string',
        'city' => 'string',
        'postal_code' => 'string',
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
