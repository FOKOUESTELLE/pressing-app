<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Payment extends Model
{
      use SoftDeletes;

    protected $fillable = [
        'order_id',
        'amount',
        'payment_date',
        'payment_method',
        'status',
    ];

    protected $casts = [
        'amount' => 'integer',
        'payment_date' => 'datetime',
    ];

     public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function receipt()
    {
        return $this->hasOne(Receipt::class);
    }
}
