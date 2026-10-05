<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class OrderItem extends Model
{
     use SoftDeletes;

    protected $fillable = [
        'quantity',
        'unit_price',
        'subtotal',
        'description',
        'order_id',
        'category_id',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'unit_price' => 'integer',
        'subtotal' => 'integer',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

       public function category()
    {
        return $this->belongsTo(Category::class);
    }
}
