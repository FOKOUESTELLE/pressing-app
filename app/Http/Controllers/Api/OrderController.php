<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use App\Notifications\PressingProNotification;

class OrderController extends Controller
{
    private const STATUSES = ['PENDING', 'PICKED_UP', 'IN_PROGRESS', 'READY', 'DELIVERED', 'CANCELLED'];

   public function index(Request $request)
    {
        $user = $request->user();

        $query = Order::with([
            'customer:id,name,phone',
            'manager:id,name',
            'orderItems.category',
            'payments.receipt',
        ])->latest('order_date');

        if ($user->role === 'CLIENT') {
            $query->where('customer_id', $user->id);
        } elseif ($user->role === 'RESPONSABLE') {
            $query->where(function ($q) use ($user) {
                $q->whereNull('manager_id')
                ->orWhere('manager_id', $user->id);
            });
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

        // Notifier tous les responsables après la création de la commande
        $responsables = User::where('role', 'RESPONSABLE')->get();

        foreach ($responsables as $responsable) {
            $responsable->notify(new PressingProNotification(
                'Nouvelle commande',
                'Une nouvelle commande vient d’être passée.',
                'NEW_ORDER',
                [
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                ]
            ));
        }

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
            $lockedOrder->manager_id = $request->user()->id;

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

        // Notifier le client
        $client = User::find($order->customer_id);

        if ($client) {
            $client->notify(new PressingProNotification(
                'Récapitulatif disponible',
                'Le récapitulatif de votre commande est prêt. Veuillez le consulter et le confirmer.',
                'RECAP_SENT',
                [
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                ]
            ));
        }

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

        // Notifier le responsable
        $responsable = User::find($order->manager_id);

        if ($responsable) {
            $responsable->notify(new PressingProNotification(
                'Récapitulatif confirmé',
                'Le client a confirmé le récapitulatif de sa commande.',
                'RECAP_CONFIRMED',
                [
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                ]
            ));
        }

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

         // Notifier le responsable
        $responsable = User::find($order->manager_id);

        if ($responsable) {
            $responsable->notify(new PressingProNotification(
                'Correction demandée',
                'Le client demande une correction du récapitulatif de sa commande.',
                'RECAP_CORRECTION_REQUESTED',
                [
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                    'correction_message' => $order->correction_message,
                ]
            ));
        }

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

        // Notifier le client du nouvel envoi
        $client = User::find($order->customer_id);

        if ($client) {
            $client->notify(new PressingProNotification(
                'Récapitulatif corrigé',
                'Le responsable a corrigé votre récapitulatif. Vous pouvez maintenant le consulter.',
                'RECAP_RESENT',
                [
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                ]
            ));
        }
        
        return response()->json([
            'success' => true,
            'message' => 'Récapitulatif envoyé avec succès.',
            'data' => $order,
        ]);
    }

   public function show(Request $request, Order $order)
    {
        $user = $request->user();

        // Vérifier les droits du client
        if (
            $user->role === 'CLIENT' &&
            (int) $order->customer_id !== (int) $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter cette commande.',
            ], 403);
        }

        // Vérifier les droits du responsable
        if (
            $user->role === 'RESPONSABLE' &&
            $order->manager_id !== null &&
            (int) $order->manager_id !== (int) $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande est attribuée à un autre responsable.',
            ], 403);
        }

        $order->load([
            'customer',
            'manager:id,name',
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
        $user = $request->user();

        $isStaff = in_array($user->role, ['RESPONSABLE', 'ADMIN']);

        // Vérifier que le client est bien propriétaire de la commande
        if ($user->role === 'CLIENT' && $order->customer_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à modifier cette commande.',
            ], 403);
        }

        // Un client ne peut modifier que sa propre commande,
        // si elle est encore en attente, non attribuée et non payée.
        if ($user->role === 'CLIENT') {

            if (
                $order->status !== 'PENDING' ||
                $order->manager_id !== null ||
                $order->payments()->exists()
            ) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cette commande ne peut plus être modifiée.',
                ], 403);
            }
        }

        $rules = [
            'recovery_mode'    => 'sometimes|in:ON_SITE,DELIVERY',
            'pickup_address'   => 'sometimes|nullable|string|max:255',
            'delivery_address' => 'sometimes|nullable|string|max:255',
        ];

        // Le personnel peut modifier le statut,
        // mais ne peut pas déclarer directement une commande livrée.
        if ($isStaff) {
            $rules['status'] = [
                'sometimes',
                Rule::in(array_diff(self::STATUSES, ['DELIVERED'])),
            ];
        }

        // Empêcher la livraison directe depuis la gestion des commandes
        if ($request->input('status') === 'DELIVERED') {
            return response()->json([
                'success' => false,
                'message' => 'Impossible de livrer directement cette commande. Le coursier doit d’abord confirmer la récupération des habits, puis leur livraison.',
            ], 422);
        }

        $validated = $request->validate($rules);

        // Vérifier que la commande est entièrement payée avant livraison
        if (($validated['status'] ?? null) === 'DELIVERED') {
            $montantPaye = $order->payments()->sum('amount');

            if ($montantPaye < $order->total) {
                return response()->json([
                    'success' => false,
                    'message' => 'Impossible de livrer cette commande : le paiement n’est pas entièrement réglé.',
                ], 422);
            }
        }

        $order->fill($validated);

        if (
            $order->recovery_mode === 'DELIVERY' &&
            empty($order->delivery_address)
        ) {
            throw ValidationException::withMessages([
                'delivery_address' => 'Une adresse de livraison est obligatoire en mode DELIVERY.',
            ]);
        }

        $order->save();
        $order->updateTotal();

        return response()->json([
            'success' => true,
            'message' => 'Commande modifiée avec succès.',
            'data' => $order,
        ]);
    }
    
    public function destroy(Request $request, Order $order)
    {
        $user = $request->user();

        // Seul le client propriétaire peut supprimer sa commande
        if (
            $user->role !== 'CLIENT' ||
            $order->customer_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à supprimer cette commande.',
            ], 403);
        }

        // La commande doit être encore en attente et non attribuée
        if (
            $order->status !== 'PENDING' ||
            $order->manager_id !== null
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne peut plus être supprimée.',
            ], 403);
        }

        // Vérifier qu'aucun paiement n'a été effectué
        if ($order->payments()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Cette commande ne peut pas être supprimée car un paiement a déjà été effectué.',
            ], 403);
        }

        $order->delete();

        return response()->json([
            'success' => true,
            'message' => 'Commande supprimée avec succès.',
        ]);
    }
}