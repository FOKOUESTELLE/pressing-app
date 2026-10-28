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

        $query = Mission::with(['order.customer:id,name,phone','coursier:id,name,phone',])->latest();

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

    
    public function takeCharge(Request $request, Order $order)
    {
        $updatedOrder = DB::transaction(function () use ($request, $order) {
            
            $lockedOrder = Order::whereKey($order->id)
                ->lockForUpdate()
                ->firstOrFail();

            // Une commande ne peut être attribuée qu'une seule fois.
            if ($lockedOrder->manager_id !== null) {
                throw ValidationException::withMessages([
                    'order' => 'Cette commande est déjà attribuée à un responsable.',
                ]);
            }

            if ($lockedOrder->status !== 'PENDING') {
                throw ValidationException::withMessages([
                    'order' => 'Seule une commande en attente peut être prise en charge.',
                ]);
            }

            // Attribue automatiquement la commande au responsable connecté.
            $lockedOrder->manager_id = $request->user()->id;

            // Passe automatiquement la commande au statut EN COURS.
            $lockedOrder->status = 'IN_PROGRESS';

            $lockedOrder->save();

            return $lockedOrder;
        });

        $updatedOrder->load(['customer', 'manager', 'orderItems.category']);

        return response()->json([
            'success' => true,
            'message' => 'Commande prise en charge avec succès.',
            'data' => $updatedOrder,
        ]);
    }

    
    public function sendRecap(Request $request, Order $order)
    {
        $user = $request->user();

        if (
            $user->role === 'RESPONSABLE'
            && $order->manager_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne vous est pas attribuée.',
            ], 403);
        }

        if ($order->status !== 'IN_PROGRESS') {
            return response()->json([
                'success' => false,
                'message' => 'La commande doit être en cours de traitement.',
            ], 409);
        }

        if ($order->orderItems()->doesntExist()) {
            return response()->json([
                'success' => false,
                'message' => 'Ajoutez au moins un article avant d’envoyer le récapitulatif.',
            ], 409);
        }

        if (! in_array($order->recap_status, ['DRAFT', 'CORRECTION_REQUESTED'])) {
            return response()->json([
                'success' => false,
                'message' => 'Le récapitulatif ne peut pas être envoyé dans son état actuel.',
            ], 409);
        }

        $order->recap_status = 'AWAITING_CONFIRMATION';
        $order->save();

        $order->load(['customer', 'orderItems.category']);

        return response()->json([
            'success' => true,
            'message' => 'Le récapitulatif a été envoyé au client pour confirmation.',
            'data' => $order,
        ]);
    }

    
    public function confirmRecap(Request $request, Order $order)
    {
        $user = $request->user();

        if ($user->role !== 'CLIENT' || $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n’êtes pas autorisé à confirmer ce récapitulatif.',
            ], 403);
        }

        if ($order->recap_status !== 'AWAITING_CONFIRMATION') {
            return response()->json([
                'success' => false,
                'message' => 'Ce récapitulatif ne peut pas être confirmé actuellement.',
            ], 409);
        }

        $order->recap_status = 'CONFIRMED';
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Récapitulatif confirmé avec succès.',
            'data' => $order,
        ]);
    }


    public function requestRecapCorrection(Request $request, Order $order)
    {
        $user = $request->user();

        if ($user->role !== 'CLIENT' || $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n’êtes pas autorisé à demander cette correction.',
            ], 403);
        }

        if ($order->recap_status !== 'AWAITING_CONFIRMATION') {
            return response()->json([
                'success' => false,
                'message' => 'Ce récapitulatif ne peut pas être corrigé actuellement.',
            ], 409);
        }

        $validated = $request->validate([
            'correction_message' => 'required|string|min:5|max:1000',
        ]);

        $order->correction_message = $validated['correction_message'];
        $order->recap_status = 'CORRECTION_REQUESTED';
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Votre demande de correction a été envoyée au responsable.',
            'data' => $order,
        ]);
    }

        public function resendRecap(Request $request, Order $order)
    {
        $user = $request->user();

        if (
            $user->role !== 'RESPONSABLE' ||
            $order->manager_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne vous est pas attribuée.',
            ], 403);
        }

        if ($order->recap_status !== 'CORRECTION_REQUESTED') {
            return response()->json([
                'success' => false,
                'message' => 'Aucune correction n\'est en attente.',
            ], 409);
        }

        $order->recap_status = 'AWAITING_CONFIRMATION';
        $order->correction_message = null;
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Récapitulatif envoyé avec succès.',
            'data' => $order,
        ]);
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
        $user = $request->user();

        // Seul le client propriétaire peut annuler sa commande.
        if ($user->role !== 'CLIENT' || $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n’êtes pas autorisé à annuler cette commande.',
            ], 403);
        }

        if (! in_array($order->recap_status, ['DRAFT', 'AWAITING_CONFIRMATION', 'CORRECTION_REQUESTED'])) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne peut plus être annulée.',
            ], 409);
        }

        if ($order->status === 'CANCELLED') {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande est déjà annulée.',
            ], 409);
        }

        // Une commande payée nécessite une procédure particulière.
        if ($order->payments()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande comporte un paiement. Contactez le pressing pour son annulation.',
            ], 409);
        }

        $order->status = 'CANCELLED';
        $order->recap_status = 'DRAFT';
        $order->correction_message = null;
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Commande annulée avec succès.',
            'data' => $order,
        ]);
    }

}