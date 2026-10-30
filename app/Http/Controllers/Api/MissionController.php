<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mission;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class MissionController extends Controller
{
    private const STATUSES = ['PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'];

    // statut actuel => statuts autorisés ensuite
    private const TRANSITIONS = [
        'PENDING'     => ['IN_PROGRESS', 'CANCELLED'],
        'IN_PROGRESS' => ['COMPLETED', 'CANCELLED'],
        'COMPLETED'   => [],
        'CANCELLED'   => [],
    ];

    private function coursierRule()
    {
        return Rule::exists('users', 'id')->where('role', 'COURSIER')->whereNull('deleted_at');
    }

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
            'type'        => 'required|in:PICKUP,DELIVERY',
            'address'     => 'required|string|max:255',
            'order_id'    => 'required|exists:orders,id',
            'coursier_id' => ['required', $this->coursierRule()],
        ]);

        $order = Order::findOrFail($validated['order_id']);

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
            ->whereIn('status', ['PENDING', 'IN_PROGRESS'])
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
                $allowed = array_intersect($allowed, ['IN_PROGRESS', 'COMPLETED']);
            }

            if (! in_array($newStatus, $allowed)) {
                throw ValidationException::withMessages([
                    'status' => 'Ce changement de statut n\'est pas autorisé.',
                ]);
            }
        }

        DB::transaction(function () use ($mission, $validated, $newStatus) {
            if (isset($validated['address'])) {
                $mission->address = $validated['address'];
            }
            if (isset($validated['coursier_id'])) {
                $mission->coursier_id = $validated['coursier_id'];
            }

            if ($newStatus !== null && $newStatus !== $mission->status) {
                $mission->status = $newStatus;

                if ($newStatus === 'COMPLETED') {
                    $mission->completed_at = now();

                    $order = Order::whereKey($mission->order_id)->lockForUpdate()->firstOrFail();

                    if ($mission->type === 'DELIVERY') {
                        if ($order->status !== 'READY') {
                            throw ValidationException::withMessages([
                                'status' => 'La commande n\'est pas prête : la livraison ne peut pas être terminée.',
                            ]);
                        }
                        $order->status = 'DELIVERED';
                        $order->save();
                    } elseif ($order->status === 'PENDING') {
                        $order->status = 'PICKED_UP';
                        $order->save();
                    }
                }
            }

            $mission->save();
        });

        return response()->json([
            'success' => true,
            'message' => 'Mission modifiée avec succès.',
            'data' => $mission->fresh(),
        ]);
    }

    public function destroy(Request $request, Mission $mission)
    {
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