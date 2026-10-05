<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Category;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $orders = Order::with(['customer', 'orderItems.category'])->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
        'order_number' => 'required|string|max:255|unique:orders,order_number',
        'order_date' => 'required|date',
        'pickup_address' => 'nullable|string|max:255',
        'delivery_address' => 'nullable|string|max:255',
        'recovery_mode' => 'required|in:ON_SITE,DELIVERY',
        'status' => 'nullable|string|max:255',
        'delivery_fee' => 'nullable|integer|min:0',
        'total' => 'nullable|integer|min:0',
        'customer_id' => 'required|exists:users,id',
    ]);

        $order = Order::create($validated);

        return response()->json([
        'success' => true,
        'message' => 'Commande créée avec succès.',
        'data' => $order,
        ], 201);

    }

    /**
     * Display the specified resource.
     */
    public function show(Order $order)
    {
        $order->load([
        'customer',
        'orderItems.category',
        ]);

        return response()->json([
        'success' => true,
        'data' => $order,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,  Order $order)
    {
         $validated = $request->validate([
        'order_number' => 'sometimes|required|string|max:255|unique:orders,order_number,' . $order->id,
        'order_date' => 'sometimes|required|date',
        'pickup_address' => 'nullable|string|max:255',
        'delivery_address' => 'nullable|string|max:255',
        'recovery_mode' => 'sometimes|required|in:ON_SITE,DELIVERY',
        'status' => 'sometimes|required|string|max:255',
        'delivery_fee' => 'sometimes|required|integer|min:0',
        'total' => 'sometimes|required|integer|min:0',
        'customer_id' => 'sometimes|required|exists:users,id',
    ]);

    $order->update($validated);

    return response()->json([
        'success' => true,
        'message' => 'Commande modifiée avec succès.',
        'data' => $order,
    ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order)
    {
        $order->delete();

        return response()->json([
            'success' => true,
            'message' => 'Commande supprimée avec succès.',
        ]);
    }
}
