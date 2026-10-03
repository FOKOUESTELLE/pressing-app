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
        'method',
        'status',
        'transaction_reference',
        'paid_at',
    ];

    protected $casts = [
        'amount' => 'integer',
        'paid_at' => 'datetime',
    ];

     public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
