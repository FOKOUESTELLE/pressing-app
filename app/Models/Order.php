<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Order extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'order_number',
        'order_date',
        'pickup_address',
        'delivery_address',
        'recovery_mode',
        'status',
        'delivery_fee',
        'total',
        'customer_id',
    ];

    protected $casts = [
        'order_date' => 'datetime',
        'delivery_fee' => 'integer',
        'total' => 'integer',
    ];

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

     public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }  
    
    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public function missions()
    {
        return $this->hasManyThrough(Receipt::class, Payment::class);
    }

    public function receipts()
    {
        return $this->hasMany(Receipt::class);
    }

    public function updateTotal()
    {
        $itemsTotal = $this->orderItems()->sum('subtotal');

        $this->total = $itemsTotal + $this->delivery_fee;

        $this->save();
    }
}
