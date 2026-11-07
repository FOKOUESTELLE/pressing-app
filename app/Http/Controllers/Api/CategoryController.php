<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $categories = Category::all();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('categories', 'name')->withoutTrashed(),
            ],
            'price' => 'required|integer|min:0',
            'description' => 'nullable|string',
            'actif' => 'sometimes|boolean',
        ]);

        $category = Category::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Catégorie créée avec succès.',
            'data' => $category,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Category $category)
    {
        return response()->json([
            'success' => true,
            'data' => $category,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Category $category)
    {
        $validated = $request->validate([
            'name' => [
                'sometimes',
                'required',
                'string',
                'max:255',
                Rule::unique('categories', 'name')
                    ->ignore($category->id)
                    ->withoutTrashed(),
            ],
            'price' => 'sometimes|required|integer|min:0',
            'description' => 'nullable|string',
            'actif' => 'sometimes|boolean',
        ]);

        $category->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Catégorie modifiée avec succès.',
            'data' => $category,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
   public function destroy(Category $category)
    {
        // Vérifier si la catégorie est utilisée dans une commande
        if ($category->orderItems()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Impossible de supprimer cette catégorie, car elle est associée à une ou plusieurs commandes.',
            ], 422);
        }

        $category->delete();

        return response()->json([
            'success' => true,
            'message' => 'Catégorie supprimée avec succès.',
        ]);
    }

    /**
 * Afficher les catégories supprimées.
 */
    public function trash()
    {
        $categories = Category::onlyTrashed()->get();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }
    /**
     * Restaurer une catégorie supprimée.
     */
    public function restore($id)
    {
        $category = Category::onlyTrashed()->find($id);

        if (!$category) {
            return response()->json([
                'success' => false,
                'message' => 'Catégorie introuvable dans la corbeille.',
            ], 404);
        }

        // Vérifier si une catégorie active utilise déjà ce nom.
        $nomExiste = Category::where('name', $category->name)->exists();

        if ($nomExiste) {
            return response()->json([
                'success' => false,
                'message' => 'Impossible de restaurer cette catégorie : son nom est déjà utilisé par une autre catégorie.',
            ], 409);
        }

        try {
            $category->restore();

            return response()->json([
                'success' => true,
                'message' => 'Catégorie restaurée avec succès.',
                'data' => $category,
            ]);

        } catch (\Illuminate\Database\QueryException $e) {
            return response()->json([
                'success' => false,
                'message' => 'La restauration a échoué en raison d’un conflit avec les données existantes.',
            ], 409);
        }
    }

    /**
     * Supprimer définitivement une catégorie.
     */
    public function forceDelete($id)
    {
        $category = Category::onlyTrashed()->find($id);

        if (!$category) {
            return response()->json([
                'success' => false,
                'message' => 'Catégorie introuvable dans la corbeille.',
            ], 404);
        }

        try {
            $category->forceDelete();

            return response()->json([
                'success' => true,
                'message' => 'Catégorie supprimée définitivement.',
            ]);

        } catch (\Illuminate\Database\QueryException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Impossible de supprimer définitivement cette catégorie, car elle est encore liée à certaines données.',
            ], 409);
        }
    }

}
