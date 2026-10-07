<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Receipt;
use Illuminate\Http\Request;

class ReceiptController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Receipt::with('payment.order')->latest('issued_at');

        // Un client ne voit que les reçus de ses propres commandes
        if ($user->role === 'CLIENT') {
            $query->whereHas('payment.order', function ($q) use ($user) {
                $q->where('customer_id', $user->id);
            });
        }

        return response()->json([
            'success' => true,
            'data' => $query->paginate(20),
        ]);
    }

    public function show(Request $request, Receipt $receipt)
    {
        $user = $request->user();

        $receipt->load('payment.order');

        $ownerId = $receipt->payment?->order?->customer_id;

        if ($user->role === 'CLIENT' && $ownerId !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à consulter ce reçu.',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $receipt,
        ]);
    }
}