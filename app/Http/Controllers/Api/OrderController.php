<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    private const STATUSES = ['PENDING', 'PICKED_UP', 'IN_PROGRESS', 'READY', 'DELIVERED', 'CANCELLED'];

    public function index(Request $request)
    {
        $user = $request->user();

        $query = Order::with(['customer', 'orderItems.category'])->latest('order_date');

        if ($user->role === 'CLIENT') {
            $query->where('customer_id', $user->id);
        }

        return response()->json([
            'success' => true,
            'data' => $query->paginate(20),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'recovery_mode'    => 'required|in:ON_SITE,DELIVERY',
            'pickup_address'   => 'nullable|string|max:255',
            'delivery_address' => 'required_if:recovery_mode,DELIVERY|nullable|string|max:255',
        ]);
        $order = DB::transaction(function () use ($validated, $request) {
        $order = new Order($validated);
        $order->customer_id  = $request->user()->id;
        $order->order_number = Order::nextOrderNumber();
        $order->order_date   = now();
        $order->status       = 'PENDING';
        $order->save();

        $order->updateTotal();

        return $order;
        });

        return response()->json([
            'success' => true,
            'message' => 'Commande créée avec succès.',
            'data' => $order,
        ], 201);
    }

    public function show(Request $request, Order $order)
    {
        $user = $request->user();

        if ($user->role === 'CLIENT' && $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter cette commande.',
            ], 403);
        }

        $order->load([
            'customer', 
            'orderItems.category', 
            'payments.receipt',
            'missions.coursier',
            ]);

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    public function update(Request $request, Order $order)
    {
        $user    = $request->user();
        $isStaff = in_array($user->role, ['RESPONSABLE', 'ADMIN']);

        if (! $isStaff && $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à modifier cette commande.',
            ], 403);
        }

        // Un client ne modifie sa commande que tant qu'elle est en attente et non payée
        if (! $isStaff && ($order->status !== 'PENDING' || $order->payments()->exists())) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne peut plus être modifiée.',
            ], 403);
        }

        $rules = [
            'recovery_mode'    => 'sometimes|in:ON_SITE,DELIVERY',
            'pickup_address'   => 'sometimes|nullable|string|max:255',
            'delivery_address' => 'sometimes|nullable|string|max:255',
        ];

        // Seul le personnel peut changer le statut
        if ($isStaff) {
            $rules['status'] = ['sometimes', Rule::in(self::STATUSES)];
        }

        $order->fill($request->validate($rules));

        if ($order->recovery_mode === 'DELIVERY' && empty($order->delivery_address)) {
            throw ValidationException::withMessages([
                'delivery_address' => 'Une adresse de livraison est obligatoire en mode DELIVERY.',
            ]);
        }

        $order->save();
        $order->updateTotal(); // recalcule les frais si le mode a changé

        return response()->json([
            'success' => true,
            'message' => 'Commande modifiée avec succès.',
            'data' => $order,
        ]);
    }

    public function destroy(Request $request, Order $order)
    {
        $user    = $request->user();
        $isStaff = in_array($user->role, ['RESPONSABLE', 'ADMIN']);

        if (! $isStaff && $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à supprimer cette commande.',
            ], 403);
        }

        if ($order->status !== 'PENDING' || $order->payments()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Seule une commande en attente et sans paiement peut être supprimée. Annulez-la plutôt (statut CANCELLED).',
            ], 409);
        }

        $order->delete();

        return response()->json([
            'success' => true,
            'message' => 'Commande supprimée avec succès.',
        ]);
    }
}