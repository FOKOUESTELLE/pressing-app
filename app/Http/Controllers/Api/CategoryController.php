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
}
