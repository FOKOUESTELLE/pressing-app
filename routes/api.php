<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\OrderItemController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ReceiptController;
use App\Http\Controllers\Api\MissionController;
use App\Http\Controllers\Api\UserController;


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])
     ->middleware('auth:sanctum');

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('categories', CategoryController::class)
     ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('orders', OrderController::class)
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);

Route::apiResource('order-items', OrderItemController::class)
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);

Route::apiResource('payments', PaymentController::class)
     ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('receipts', ReceiptController::class)
     ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);  

// Consulter les missions
Route::get('/missions', [MissionController::class, 'index'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::get('/missions/{mission}', [MissionController::class, 'show'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

// Modifier une mission
Route::put('/missions/{mission}', [MissionController::class, 'update'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::patch('/missions/{mission}', [MissionController::class, 'update'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

// Créer une mission : uniquement RESPONSABLE et ADMIN
Route::post('/missions', [MissionController::class, 'store'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

// Supprimer une mission : uniquement RESPONSABLE et ADMIN
Route::delete('/missions/{mission}', [MissionController::class, 'destroy'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('users', UserController::class)->middleware(['auth:sanctum', 'admin'])
     ->middleware(['auth:sanctum', 'admin']);

