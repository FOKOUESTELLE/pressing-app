<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class PaymentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $payments = Payment::with(['order', 'receipt'])
            ->latest('payment_date')
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $payments,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {

        $validated = $request->validate([
            'amount'         => 'required|integer|min:1',
            'payment_method' => 'required|in:CASH,MOBILE_MONEY,CARD',
            'order_id'       => 'required|exists:orders,id',
        ]);

        $payment = DB::transaction(function () use ($validated) {
            // Verrou : deux paiements simultanés sur la même commande
            // sont traités l'un après l'autre, jamais en parallèle.
            $order = Order::whereKey($validated['order_id'])
                ->lockForUpdate()
                ->firstOrFail();

            if ($order->status === 'CANCELLED') {
                throw ValidationException::withMessages([
                    'order_id' => 'Cette commande est annulée.',
                ]);
            }

            if ($order->total <= 0) {
                throw ValidationException::withMessages([
                    'order_id' => 'Cette commande n\'a aucun montant à payer.',
                ]);
            }

            $alreadyPaid = (int) $order->payments()->sum('amount');
            $remaining   = $order->total - $alreadyPaid;

            if ($remaining <= 0) {
                throw ValidationException::withMessages([
                    'order_id' => 'Cette commande est déjà entièrement payée.',
                ]);
            }

            if ($validated['amount'] > $remaining) {
                throw ValidationException::withMessages([
                    'amount' => "Le montant dépasse le reste à payer ($remaining FCFA).",
                ]);
            }

            $payment = $order->payments()->create([
                'amount'         => $validated['amount'],
                'payment_method' => $validated['payment_method'],
                'payment_date'   => now(),
                'status'         => $validated['amount'] === $remaining ? 'PAID' : 'PARTIAL',
            ]);

            // Un paiement = un reçu, créé automatiquement
            $payment->receipt()->create([
                'receipt_number' => 'REC-' . now()->format('Ymd') . '-' . str_pad($payment->id, 6, '0', STR_PAD_LEFT),
                'issued_at'      => now(),
                'amount'         => $payment->amount,
            ]);

            return $payment;
        });

        return response()->json([
            'success' => true,
            'message' => 'Paiement enregistré avec succès.',
            'data'    => $payment->load(['order', 'receipt']),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Payment $payment)
    {
        $payment->load(['order', 'receipt']);

        return response()->json([
            'success' => true,
            'data' => $payment,
        ]);
    }

}
