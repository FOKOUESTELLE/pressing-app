<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;


class Order extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'pickup_address',
        'delivery_address',
        'recovery_mode',
        'status',
    ];

    public const RECAP_STATUSES = [
        'DRAFT',
        'AWAITING_CONFIRMATION',
        'CORRECTION_REQUESTED',
        'CONFIRMED',
    ];

    // protected $casts = [
    //     'order_date' => 'datetime',
    //     'delivery_fee' => 'integer',
    //     'total' => 'integer',
    // ];

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function manager()
    {
        return $this->belongsTo(User::class, 'manager_id');
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

    public function receipts()
    {
        return $this->hasManyThrough(Receipt::class, Payment::class);
    }

    public function updateTotal()
    {
        $this->delivery_fee = $this->recovery_mode === 'DELIVERY'
            ? config('pressing.delivery_fee')
            : 0;

        $this->total = (int) $this->orderItems()->sum('subtotal') + $this->delivery_fee;

        $this->save();
    }

    public static function nextOrderNumber(): string
    {
        if (DB::transactionLevel() === 0) {
            throw new \LogicException('nextOrderNumber() doit être appelée dans une transaction.');
        }

        $year = now()->year;

        // Crée la ligne de l'année si elle n'existe pas encore
        DB::table('order_counters')->insertOrIgnore(['year' => $year, 'last_number' => 0]);

        // Verrouille la ligne : un autre client attend la fin de cette transaction
        $last = DB::table('order_counters')
            ->where('year', $year)
            ->lockForUpdate()
            ->value('last_number');

        $next = $last + 1;

        DB::table('order_counters')->where('year', $year)->update(['last_number' => $next]);

        return sprintf('CMD-%s-%06d', now()->format('Ymd'), $next);
    }

    public function isRecapAwaitingConfirmation(): bool
    {
        return $this->recap_status === 'AWAITING_CONFIRMATION';
    }
}
