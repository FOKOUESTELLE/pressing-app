<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\Order;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $payments = Payment::with('order')->get();

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
        'amount' => 'required|integer|min:1',
        'payment_date' => 'required|date',
        'payment_method' => 'required|in:CASH,MOBILE_MONEY,CARD',
        'status' => 'nullable|string|max:255',
        'order_id' => 'required|exists:orders,id',
    ]);

    $payment = Payment::create($validated);

    return response()->json([
        'success' => true,
        'message' => 'Paiement enregistré avec succès.',
        'data' => $payment,
    ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $payment = Payment::with('order')->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $payment,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,  Payment $payment)
    {
        
        $validated = $request->validate([
            'amount' => 'sometimes|required|integer|min:1',
            'payment_date' => 'sometimes|required|date',
            'payment_method' => 'sometimes|required|in:CASH,MOBILE_MONEY,CARD',
            'status' => 'sometimes|required|string|max:255',
        ]);

        $payment->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Paiement modifié avec succès.',
            'data' => $payment,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Payment $payment)
    {
        $payment->delete();

        return response()->json([
            'success' => true,
            'message' => 'Paiement supprimé avec succès.',
        ]);
    }
}
