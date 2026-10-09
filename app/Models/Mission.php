<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Mission extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'type',
        'address',
        'order_id',
        'coursier_id',
    ];

    // protected $casts = [
    //      'assigned_at' => 'datetime',
    //     'completed_at' => 'datetime',
    // ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function coursier()
    {
        return $this->belongsTo(User::class, 'coursier_id');
    }


    
}
