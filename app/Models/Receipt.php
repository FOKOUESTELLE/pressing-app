<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Receipt extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'order_id',
        'receipt_number',
        'amount',
        'issued_at',
    ];

    protected $casts = [
        'amount' => 'integer',
        'issued_at' => 'datetime',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
