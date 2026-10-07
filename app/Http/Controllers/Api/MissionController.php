<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mission;
use App\Models\User;
use Illuminate\Http\Request;

class MissionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'COURSIER') {
            $missions = Mission::with(['order', 'coursier'])
                ->where('coursier_id', $user->id)
                ->get();
        } else {
            $missions = Mission::with(['order', 'coursier'])->get();
        }

        return response()->json([
            'success' => true,
            'data' => $missions,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => 'required|in:PICKUP,DELIVERY',
            'status' => 'nullable|string|max:255',
            'assigned_at' => 'nullable|date',
            'completed_at' => 'nullable|date',
            'address' => 'required|string|max:255',
            'order_id' => 'required|exists:orders,id',
            'coursier_id' => [
                'required',
                'exists:users,id',
                function ($attribute, $value, $fail) {
                    $user = User::find($value);

                    if ($user && $user->role !== 'COURSIER') {
                        $fail('L’utilisateur sélectionné doit avoir le rôle COURSIER.');
                    }
                },
            ],
        ]);

        $mission = Mission::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Mission créée avec succès.',
            'data' => $mission,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, Mission $mission)
    {
        $user = $request->user();

        if (
            $user->role === 'COURSIER' &&
            $mission->coursier_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter cette mission.',
            ], 403);
        }

        $mission->load(['order', 'coursier']);

        return response()->json([
            'success' => true,
            'data' => $mission,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Mission $mission)
    {
        $user = $request->user();

        if (
            $user->role === 'COURSIER' &&
            $mission->coursier_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à modifier cette mission.',
            ], 403);
        }

        $validated = $request->validate([
            'type' => 'sometimes|required|in:PICKUP,DELIVERY',
            'status' => 'sometimes|required|string|max:255',
            'assigned_at' => 'sometimes|nullable|date',
            'completed_at' => 'sometimes|nullable|date',
            'address' => 'sometimes|required|string|max:255',
            'order_id' => 'sometimes|required|exists:orders,id',
            'coursier_id' => [
                'sometimes',
                'required',
                'exists:users,id',
                function ($attribute, $value, $fail) {
                    $user = User::find($value);

                    if ($user && $user->role !== 'COURSIER') {
                        $fail('L’utilisateur sélectionné doit avoir le rôle COURSIER.');
                    }
                },
            ],
        ]);

        /*
         * Un coursier ne peut pas transférer sa mission
         * à un autre coursier.
         */
        if (
            $user->role === 'COURSIER' &&
            isset($validated['coursier_id']) &&
            $validated['coursier_id'] != $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Un coursier ne peut pas attribuer sa mission à un autre coursier.',
            ], 403);
        }
        if (
            isset($validated['status']) &&
            $validated['status'] === 'COMPLETED'
        ){
            $validated['completed_at'] = now();
         }

        $mission->update($validated);

        if (
            $mission->type === 'DELIVERY' &&
            $mission->status === 'COMPLETED'
        ) {
            $mission->order->update([
                'status' => 'DELIVERED',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Mission modifiée avec succès.',
            'data' => $mission,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Mission $mission)
    {
        $user = $request->user();

        if ($user->role === 'COURSIER') {
            return response()->json([
                'success' => false,
                'message' => 'Les coursiers ne sont pas autorisés à supprimer une mission.',
            ], 403);
        }

        $mission->delete();

        return response()->json([
            'success' => true,
            'message' => 'Mission supprimée avec succès.',
        ]);
    }
}