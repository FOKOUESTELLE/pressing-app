<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Order extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'order_number',
        'status',
        'total_amount',
        'pickup_date',
        'delivery_date',
    ];

    protected $casts = [
        'total_amount' => 'integer',
        'pickup_date' => 'date',
        'delivery_date' => 'date',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
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
        return $this->hasMany(Mission::class);
    }

    public function receipt()
    {
        return $this->hasOne(Receipt::class);
    }
}
