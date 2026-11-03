<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Validation\Rule;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $users = User::all(); 
        return response()->json([ 
            'success' => true, 
            'data' => $users, 
            ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([ 
            'name' => 'required|string|max:255', 
            'email' => 'required|email|max:255|unique:users,email', 
            'password' => 'required|string|min:8', 
            'phone' => 'required|string|max:20', 
            'address' => 'required|string|max:255', 
            'role' => [ 'required', Rule::in([ 'CLIENT', 'COURSIER', 'RESPONSABLE', 'ADMIN', ]), ], ]);

            $user = User::create($validated); 
            return response()->json([ 
                'success' => true, 
                'message' => 'Utilisateur créé avec succès.', 
                'data' => $user, 
                ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
         return response()->json([
            'success' => true,
            'data' => $user,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',

            'email' => [
                'sometimes',
                'required',
                'email',
                'max:255',
                Rule::unique('users', 'email')->ignore($user->id),
            ],

            'password' => 'sometimes|required|string|min:8',
            'phone' => 'sometimes|required|string|max:20',
            'address' => 'sometimes|required|string|max:255',

            'role' => [
                'sometimes',
                'required',
                Rule::in([
                    'CLIENT',
                    'COURSIER',
                    'RESPONSABLE',
                    'ADMIN',
                ]),
            ],
        ]);

        $user->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Utilisateur modifié avec succès.',
            'data' => $user,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'Utilisateur supprimé avec succès.',
        ]);
    }

    /**
 * Modifier le profil de l'utilisateur connecté.
 */
public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'email' => [
                'sometimes',
                'required',
                'email',
                'max:255',
                Rule::unique('users', 'email')->ignore($user->id),
            ],
            'phone' => 'sometimes|nullable|string|max:20',
            'address' => 'sometimes|nullable|string|max:255',
        ]);

        $user->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Profil mis à jour avec succès.',
            'data' => $user,
        ]);
    }

    /**
 * Modifier le mot de passe de l'utilisateur connecté.
 */
public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ], [
            'current_password.required' => 'Veuillez saisir votre mot de passe actuel.',
            'password.required' => 'Veuillez saisir un nouveau mot de passe.',
            'password.min' => 'Le nouveau mot de passe doit contenir au moins 8 caractères.',
            'password.confirmed' => 'La confirmation du mot de passe ne correspond pas.',
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Votre mot de passe actuel est incorrect.',
            ], 422);
        }

        $user->password = $request->password;
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Votre mot de passe a été modifié avec succès.',
        ]);
    }

    public function coursiers()
    {
        $coursiers = User::where('role', 'COURSIER')
            ->whereNull('deleted_at')
            ->select('id', 'name', 'phone')
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $coursiers,
        ]);
    }
}
