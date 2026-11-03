<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Category extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name',
        'price',
        'description',
        'actif',
    ];

    protected $casts = [
        'price' => 'integer',
        'actif' => 'boolean',
    ];

     public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}
