<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\OrderItem;
use App\Models\Category;
use Illuminate\Http\Request;

class OrderItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'CLIENT') {
            $orderItems = OrderItem::with(['order', 'category'])
                ->whereHas('order', function ($query) use ($user) {
                    $query->where('customer_id', $user->id);
                })
                ->get();
        } else {
            $orderItems = OrderItem::with(['order', 'category'])->get();
        }

        return response()->json([
            'success' => true,
            'data' => $orderItems,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'quantity' => 'required|integer|min:1',
            'description' => 'required|string',
            'order_id' => 'required|exists:orders,id',
            'category_id' => 'required|exists:categories,id',
        ]);

        $order = \App\Models\Order::findOrFail($validated['order_id']);

        if ($user->role === 'CLIENT' && $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à ajouter un article à cette commande.',
            ], 403);
        }

        $category = Category::findOrFail($validated['category_id']);

        $validated['unit_price'] = $category->price;

        $validated['subtotal'] =
            $validated['quantity'] * $validated['unit_price'];

        $orderItem = OrderItem::create($validated);

        $orderItem->order->updateTotal();

        return response()->json([
            'success' => true,
            'message' => 'Article ajouté à la commande avec succès.',
            'data' => $orderItem,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, OrderItem $orderItem)
    {
        $user = $request->user();

        if (
            $user->role === 'CLIENT' &&
            $orderItem->order->customer_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter cet article.',
            ], 403);
        }

        $orderItem->load(['order', 'category']);

        return response()->json([
            'success' => true,
            'data' => $orderItem,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, OrderItem $orderItem)
    {
        $user = $request->user();

        if (
            $user->role === 'CLIENT' &&
            $orderItem->order->customer_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à modifier cet article.',
            ], 403);
        }

        $validated = $request->validate([
            'quantity' => 'sometimes|required|integer|min:1',
            'description' => 'sometimes|required|string',
            'category_id' => 'sometimes|required|exists:categories,id',
        ]);

        if (isset($validated['category_id'])) {
            $category = Category::findOrFail($validated['category_id']);

            $validated['unit_price'] = $category->price;
        }

        if (
            isset($validated['quantity']) ||
            isset($validated['unit_price'])
        ) {
            $quantity = $validated['quantity'] ?? $orderItem->quantity;
            $unitPrice = $validated['unit_price'] ?? $orderItem->unit_price;

            $validated['subtotal'] = $quantity * $unitPrice;
        }

        $orderItem->update($validated);

        $orderItem->order->updateTotal();

        return response()->json([
            'success' => true,
            'message' => 'Article modifié avec succès.',
            'data' => $orderItem,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, OrderItem $orderItem)
    {
        $user = $request->user();

        if (
            $user->role === 'CLIENT' &&
            $orderItem->order->customer_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à supprimer cet article.',
            ], 403);
        }

        $order = $orderItem->order;

        $orderItem->delete();

        $order->updateTotal();

        return response()->json([
            'success' => true,
            'message' => 'Article supprimé de la commande avec succès.',
        ]);
    }
}
