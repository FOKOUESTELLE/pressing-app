<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mission;
use Illuminate\Http\Request;

class MissionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $missions = Mission::with(['order', 'coursier'])->get();

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
                                    $user = \App\Models\User::find($value);

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
    public function show(Mission $mission)
    {
        
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
                                    $user = \App\Models\User::find($value);

                                    if ($user && $user->role !== 'COURSIER') {
                                        $fail('L’utilisateur sélectionné doit avoir le rôle COURSIER.');
                                    }
                                },
                            ],
        ]);

        $mission->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Mission modifiée avec succès.',
            'data' => $mission,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Mission $mission)
    {
        $mission->delete();

        return response()->json([
            'success' => true,
            'message' => 'Mission supprimée avec succès.',
        ]); 
    }
}
