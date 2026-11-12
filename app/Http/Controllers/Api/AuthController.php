<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'phone' => ['required','string','regex:/^\+[1-9][0-9]{7,14}$/'],
            'address' => 'required|string|max:255',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'phone' => $validated['phone'],
            'address' => $validated['address'],
            'role' => 'CLIENT',
        ]);

        $token = $user->createToken('pressing-app-token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Compte créé avec succès.',
            'data' => [
                'user' => $user,
                'token' => $token,
            ],
        ], 201);
    }

     public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email ou mot de passe incorrect.',
            ], 401);
        }

        $token = $user->createToken('pressing-app-token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Connexion réussie.',
            'data' => [
                'user' => $user,
                'token' => $token,
            ],
        ]);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $status = Password::sendResetLink(
            $request->only('email')
        );

        if ($status === Password::RESET_LINK_SENT) {
            return response()->json([
                'success' => true,
                'message' => 'Votre demande a été prise en compte. Si un compte est associé à cette adresse e-mail, vous recevrez un lien pour réinitialiser votre mot de passe.',
            ]);
        }

        if ($status === Password::INVALID_USER) {
            return response()->json([
                'success' => true,
                'message' => 'Votre demande a été prise en compte. Si un compte est associé à cette adresse e-mail, vous recevrez les instructions de réinitialisation.',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Nous n\'avons pas pu traiter votre demande pour le moment. Veuillez réessayer dans quelques instants.',
        ], 500);
    }
    
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),

            function ($user, $password) {
                $user->forceFill([
                    'password' => $password,
                    'remember_token' => Str::random(60),
                ])->save();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json([
                'success' => true,
                'message' => 'Votre mot de passe a été réinitialisé avec succès.',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Le lien de réinitialisation est invalide ou a expiré.',
        ], 422);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Déconnexion réussie.',
        ]);
    }
}