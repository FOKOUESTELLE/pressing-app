<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mission;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use App\Notifications\PressingProNotification;

class MissionController extends Controller
{
    private const STATUSES = ['PENDING', 'IN_PROGRESS', 'AWAITING_CONFIRMATION', 'COMPLETED', 'CANCELLED'];

    // statut actuel => statuts autorisés ensuite
    private const TRANSITIONS = [
    'PENDING' => ['IN_PROGRESS', 'CANCELLED'],
    'IN_PROGRESS' => ['AWAITING_CONFIRMATION', 'CANCELLED'],
    'AWAITING_CONFIRMATION' => [],
    'COMPLETED' => [],
    'CANCELLED' => [],
];

    private function coursierRule()
    {
        return Rule::exists('users', 'id')->where('role', 'COURSIER')->whereNull('deleted_at');
    }

    private function responsableCanAccessMission($user, Mission $mission)
    {
        if ($user->role !== 'RESPONSABLE') {
            return true;
        }

        return Order::whereKey($mission->order_id)
            ->where('manager_id', $user->id)
            ->exists();
    }

    public function index(Request $request)
    {
        $user = $request->user();

       $query = Mission::with([
            'order',
            'order.customer',
            'coursier:id,name,phone',
        ])->latest();

        // Le coursier consulte uniquement ses propres missions.
        if ($user->role === 'COURSIER') {
            $query->where('coursier_id', $user->id);
        }

        // Le responsable consulte uniquement les missions
        // des commandes qui lui sont attribuées.
        elseif ($user->role === 'RESPONSABLE') {
            $query->whereHas('order', function ($q) use ($user) {
                $q->where('manager_id', $user->id);
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
            'type'        => 'required|in:PICKUP,DELIVERY',
            'address'     => 'required|string|max:255',
            'order_id'    => 'required|exists:orders,id',
            'coursier_id' => ['required', $this->coursierRule()],
        ]);

        $order = Order::findOrFail($validated['order_id']);

        // Un responsable ne peut créer une mission
        // que pour une commande qui lui est attribuée.
        if (
            $request->user()->role === 'RESPONSABLE' &&
            (int) $order->manager_id !== (int) $request->user()->id
        ) {
            throw ValidationException::withMessages([
                'order_id' => 'Cette commande ne vous est pas attribuée.',
            ]);
        }
        if (in_array($order->status, ['DELIVERED', 'CANCELLED'])) {
            throw ValidationException::withMessages([
                'order_id' => 'Cette commande est terminée ou annulée.',
            ]);
        }

        if ($validated['type'] === 'DELIVERY' && $order->recovery_mode !== 'DELIVERY') {
            throw ValidationException::withMessages([
                'type' => 'Cette commande n\'est pas en mode livraison.',
            ]);
        }

        $alreadyActive = Mission::where('order_id', $order->id)
            ->where('type', $validated['type'])
            ->whereIn('status', [
                'PENDING',
                'IN_PROGRESS',
                'AWAITING_CONFIRMATION'
            ])
            ->exists();

        if ($alreadyActive) {
            throw ValidationException::withMessages([
                'type' => 'Une mission de ce type est déjà en cours pour cette commande.',
            ]);
        }

        $mission = new Mission($validated);
        $mission->status      = 'PENDING';
        $mission->assigned_at = now();
        $mission->save();

        // Notifier le coursier de sa nouvelle mission
        $coursier = User::find($mission->coursier_id);

        if ($coursier) {
            $coursier->notify(new PressingProNotification(
                'Nouvelle mission attribuée',
                'Une nouvelle mission vous a été attribuée pour une commande.',
                'NEW_MISSION',
                [
                    'mission_id' => $mission->id,
                    'order_id' => $order->id,
                    'order_number' => $order->order_number,
                    'mission_type' => $mission->type,
                ]
            ));
        }

        return response()->json([
            'success' => true,
            'message' => 'Mission créée avec succès.',
            'data' => $mission,
        ], 201);
    }

    public function show(Request $request, Mission $mission)
    {
        $user = $request->user();

        if ($user->role === 'COURSIER' && $mission->coursier_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter cette mission.',
            ], 403);
        }

        if (! $this->responsableCanAccessMission($user, $mission)) {
            return response()->json([
                'success' => false,
                'message' => 'Cette mission ne vous est pas attribuée.',
            ], 403);
        }

        $mission->load(['order', 'coursier:id,name,phone']);

        return response()->json([
            'success' => true,
            'data' => $mission,
        ]);
    }

    public function update(Request $request, Mission $mission)
    {
        $user       = $request->user();
        $isCoursier = $user->role === 'COURSIER';

        if ($isCoursier && $mission->coursier_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à modifier cette mission.',
            ], 403);
        }

        if (! $this->responsableCanAccessMission($user, $mission)) {
            return response()->json([
                'success' => false,
                'message' => 'Cette mission ne vous est pas attribuée.',
            ], 403);
        }

        if (empty(self::TRANSITIONS[$mission->status])) {
            return response()->json([
                'success' => false,
                'message' => 'Cette mission est terminée ou annulée et ne peut plus être modifiée.',
            ], 409);
        }

        // Le coursier ne peut modifier que le statut ; tout autre champ envoyé est ignoré
        $rules = ['status' => ['sometimes', Rule::in(self::STATUSES)]];

        if (! $isCoursier) {
            $rules['address']     = 'sometimes|string|max:255';
            $rules['coursier_id'] = ['sometimes', $this->coursierRule()];
        }

        $validated = $request->validate($rules);
        $newStatus = $validated['status'] ?? null;

        if ($newStatus !== null && $newStatus !== $mission->status) {
            $allowed = self::TRANSITIONS[$mission->status];

       if ($isCoursier) {
            $allowed = array_intersect(
                $allowed,
                ['IN_PROGRESS', 'AWAITING_CONFIRMATION']
            );
        }elseif ($user->role === 'RESPONSABLE') {
                    $allowed = array_intersect($allowed, ['CANCELLED']);
                }

            if (! in_array($newStatus, $allowed)) {
                throw ValidationException::withMessages([
                    'status' => 'Ce changement de statut n\'est pas autorisé.',
                ]);
            }
        }

        $ancienCoursierId = $mission->coursier_id;
        $ancienStatut = $mission->status;

        DB::transaction(function () use ($mission, $validated, $newStatus) {
            if (isset($validated['address'])) {
                $mission->address = $validated['address'];
            }
            if (isset($validated['coursier_id'])) {
                $mission->coursier_id = $validated['coursier_id'];
            }

            if ($newStatus !== null && $newStatus !== $mission->status) {
                $mission->status = $newStatus;
            }

            $mission->save();
        });

        // Récupérer la mission mise à jour
        $mission = $mission->fresh();

        // Récupérer la commande concernée
        $order = Order::find($mission->order_id);

        // Demander au client de confirmer la réalisation
        if (
            $ancienStatut !== $mission->status &&
            $mission->status === 'AWAITING_CONFIRMATION'
        ) {
            $client = User::find($order->customer_id);

            if ($client) {
                $client->notify(new PressingProNotification(
                    'Confirmation de mission requise',
                    'Le coursier déclare avoir effectué sa mission. Veuillez confirmer sa réalisation.',
                    'MISSION_AWAITING_CONFIRMATION',
                    [
                        'mission_id' => $mission->id,
                        'order_id' => $order->id,
                        'order_number' => $order->order_number,
                        'mission_type' => $mission->type,
                    ]
                ));
            }
        }

        // Notifier le nouveau coursier en cas de réattribution
        if (
            $mission->coursier_id != $ancienCoursierId &&
            $mission->coursier_id
        ) {
            $nouveauCoursier = User::find($mission->coursier_id);

            if ($nouveauCoursier) {
                $nouveauCoursier->notify(new PressingProNotification(
                    'Mission réattribuée',
                    'Une mission vous a été attribuée.',
                    'MISSION_REASSIGNED',
                    [
                        'mission_id' => $mission->id,
                        'order_id' => $order->id,
                        'order_number' => $order->order_number,
                        'mission_type' => $mission->type,
                    ]
                ));
            }
        }

        // Notifier le responsable en cas d'annulation
        if (
            $ancienStatut !== $mission->status &&
            $mission->status === 'CANCELLED'
        ) {
            $responsable = User::find($order->manager_id);

            if ($responsable) {
                $responsable->notify(new PressingProNotification(
                    'Mission annulée',
                    'La mission de la commande ' . $order->order_number . ' a été annulée.',
                    'MISSION_CANCELLED',
                    [
                        'mission_id' => $mission->id,
                        'order_id' => $order->id,
                        'order_number' => $order->order_number,
                        'mission_type' => $mission->type,
                    ]
                ));
            }
        }

            return response()->json([
                'success' => true,
                'message' => 'Mission modifiée avec succès.',
                'data' => $mission->fresh(),
            ]);
        }

        public function confirmCompletion(Request $request, Mission $mission)
        {
            $user = $request->user();

            // Vérifier que la commande appartient au client connecté
            $order = Order::whereKey($mission->order_id)
                ->where('customer_id', $user->id)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cette mission ne concerne pas votre commande.',
                ], 403);
            }

            // Vérifier que le coursier a déclaré la mission effectuée
            if ($mission->status !== 'AWAITING_CONFIRMATION') {
                return response()->json([
                    'success' => false,
                    'message' => 'Cette mission ne nécessite pas de confirmation.',
                ], 409);
            }

            DB::transaction(function () use ($mission, $order) {

                $mission = Mission::whereKey($mission->id)
                    ->lockForUpdate()
                    ->firstOrFail();

                $order = Order::whereKey($order->id)
                    ->lockForUpdate()
                    ->firstOrFail();

                // Nouvelle vérification pour éviter une double confirmation
                if ($mission->status !== 'AWAITING_CONFIRMATION') {
                    throw ValidationException::withMessages([
                        'mission' => 'Cette mission a déjà été traitée.',
                    ]);
                }

                if ($mission->type === 'DELIVERY') {

                    if ($order->status !== 'READY') {
                        throw ValidationException::withMessages([
                            'mission' => 'La commande n\'est pas prête à être livrée.',
                        ]);
                    }

                    $order->status = 'DELIVERED';
                    $order->save();

                } elseif ($mission->type === 'PICKUP') {

                    if ($order->status === 'PENDING') {
                        $order->status = 'PICKED_UP';
                        $order->save();
                    }
                }

                $mission->status = 'COMPLETED';
                $mission->completed_at = now();
                $mission->save();
            });

            $mission->refresh();
            $order->refresh();

            // Informer le responsable
            $responsable = User::find($order->manager_id);

            if ($responsable) {
                $responsable->notify(new PressingProNotification(
                    'Mission confirmée',
                    'Le client a confirmé la réalisation de la mission de la commande ' . $order->order_number . '.',
                    'MISSION_COMPLETED',
                    [
                        'mission_id' => $mission->id,
                        'order_id' => $order->id,
                        'order_number' => $order->order_number,
                        'mission_type' => $mission->type,
                    ]
                ));
            }

            // Informer le coursier
            $coursier = User::find($mission->coursier_id);

            if ($coursier) {
                $coursier->notify(new PressingProNotification(
                    'Mission confirmée par le client',
                    'Le client a confirmé que votre mission a bien été effectuée.',
                    'MISSION_CONFIRMED',
                    [
                        'mission_id' => $mission->id,
                        'order_id' => $order->id,
                        'order_number' => $order->order_number,
                    ]
                ));
            }

            return response()->json([
                'success' => true,
                'message' => 'Mission confirmée avec succès.',
                'data' => $mission,
            ]);
        }

        public function destroy(Request $request, Mission $mission)
        {
            $user = $request->user();
            if ($request->user()->role === 'COURSIER') {
                return response()->json([
                    'success' => false,
                    'message' => 'Les coursiers ne sont pas autorisés à supprimer une mission.',
                ], 403);
            }

            if ($mission->status !== 'PENDING') {
                return response()->json([
                    'success' => false,
                    'message' => 'Seule une mission non démarrée peut être supprimée ; annulez-la plutôt.',
                ], 409);
            }

            $mission->delete();

            return response()->json([
                'success' => true,
                'message' => 'Mission supprimée avec succès.',
            ]);
        }
    }