<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Softdeletes;

class Category extends Model
{
    use Softdeletes;

    protected $fillable = [
        'name',
        'price',
        'description',
    ];

    protected $casts = [
        'price' => 'integer',
    ];

     public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}
