<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Receipt;
use App\Models\Order;
use App\Models\Payment;
use Illuminate\Http\Request;

class ReceiptController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $receipts = Receipt::with('order')->get();

        return response()->json([
            'success' => true,
            'data' => $receipts,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'receipt_number' => 'required|string|max:255|unique:receipts,receipt_number',
            'issued_at' => 'required|date',
            'amount' => 'required|integer|min:1',
            'order_id' => 'required|exists:orders,id',
        ]);

        $order = Order::findOrFail($validated['order_id']);

        $paidAmount = Payment::where('order_id', $order->id)
            ->sum('amount');

        if ($validated['amount'] > $paidAmount) {
            return response()->json([
                'success' => false,
                'message' => 'Le montant du reçu dépasse le montant réellement payé pour cette commande.',
                'paid_amount' => $paidAmount,
            ], 422);
        }

        if ($validated['amount'] > $order->total) {
            return response()->json([
                'success' => false,
                'message' => 'Le montant du reçu dépasse le montant total de la commande.',
                'order_total' => $order->total,
            ], 422);
        }

        $receipt = Receipt::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Reçu créé avec succès.',
            'data' => $receipt,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Receipt $receipt)
    {
        $receipt->load('order');

        return response()->json([
            'success' => true,
            'data' => $receipt,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,  Receipt $receipt)
    {
        $validated = $request->validate([
            'receipt_number' => 'sometimes|required|string|max:255|unique:receipts,receipt_number,' . $receipt->id,
            'issued_at' => 'sometimes|required|date',
            'amount' => 'sometimes|required|integer|min:1',
            'order_id' => 'sometimes|required|exists:orders,id',
        ]);

        $orderId = $validated['order_id'] ?? $receipt->order_id;

        $order = Order::findOrFail($orderId);

        $paidAmount = Payment::where('order_id', $order->id)
            ->sum('amount');

        if (isset($validated['amount'])) {

            if ($validated['amount'] > $paidAmount) {
                return response()->json([
                    'success' => false,
                    'message' => 'Le montant du reçu dépasse le montant réellement payé pour cette commande.',
                    'paid_amount' => $paidAmount,
                ], 422);
            }

            if ($validated['amount'] > $order->total) {
                return response()->json([
                    'success' => false,
                    'message' => 'Le montant du reçu dépasse le montant total de la commande.',
                    'order_total' => $order->total,
                ], 422);
            }
        }

        $receipt->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Reçu modifié avec succès.',
            'data' => $receipt,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Receipt $receipt)
    {
        $receipt->delete();

        return response()->json([
            'success' => true,
            'message' => 'Reçu supprimé avec succès.',
        ]);
    }
}
