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
use App\Http\Controllers\Api\NotificationController;


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);
Route::post('/logout', [AuthController::class, 'logout'])
     ->middleware('auth:sanctum');

    // Gestion de la corbeille des utilisateurs
Route::get('/users-trash', [UserController::class, 'trash'])
    ->middleware(['auth:sanctum', 'role:ADMIN']);

Route::patch('/users/{id}/restore', [UserController::class, 'restore'])
    ->middleware(['auth:sanctum', 'role:ADMIN']);

Route::delete('/users/{id}/force-delete', [UserController::class, 'forceDelete'])
    ->middleware(['auth:sanctum', 'role:ADMIN']);

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::put('/user/profile', [UserController::class, 'updateProfile'])
    ->middleware('auth:sanctum');

Route::put('/user/change-password', [UserController::class, 'changePassword'])
    ->middleware('auth:sanctum');

Route::get('/coursiers', [UserController::class, 'coursiers'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('categories', CategoryController::class)
     ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);
     
     // Gestion de la corbeille des catégories
Route::get('/categories-trash', [CategoryController::class, 'trash'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::patch('/categories/{id}/restore', [CategoryController::class, 'restore'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::delete('/categories/{id}/force-delete', [CategoryController::class, 'forceDelete'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('orders', OrderController::class)
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);
     
Route::patch('/orders/{order}/take-charge', [OrderController::class, 'takeCharge'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::post('/orders/{order}/send-recap', [OrderController::class, 'sendRecap'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::post('/orders/{order}/confirm-recap', [OrderController::class, 'confirmRecap'])
    ->middleware(['auth:sanctum', 'role:CLIENT']);

Route::post('/orders/{order}/request-recap-correction', [OrderController::class, 'requestRecapCorrection'])
    ->middleware(['auth:sanctum', 'role:CLIENT']);

Route::post('/orders/{order}/resend-recap', [OrderController::class, 'resendRecap'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE']);
    
Route::apiResource('order-items', OrderItemController::class)
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);

Route::apiResource('payments', PaymentController::class)
     ->only(['index', 'show', 'store'])
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);

Route::apiResource('receipts', ReceiptController::class)
     ->only(['index', 'show'])
     ->middleware(['auth:sanctum', 'role:CLIENT,RESPONSABLE,ADMIN']);  

// Consulter les missions
Route::get('/missions', [MissionController::class, 'index'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::get('/missions/{mission}', [MissionController::class, 'show'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::put('/missions/{mission}', [MissionController::class, 'update'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::patch('/missions/{mission}', [MissionController::class, 'update'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,COURSIER,ADMIN']);

Route::post('/missions', [MissionController::class, 'store'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);


Route::delete('/missions/{mission}', [MissionController::class, 'destroy'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::get('/users', [UserController::class, 'index'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::get('/users/{user}', [UserController::class, 'show'])
    ->middleware(['auth:sanctum', 'role:RESPONSABLE,ADMIN']);

Route::apiResource('users', UserController::class)
    ->except(['index', 'show'])
    ->middleware(['auth:sanctum', 'role:ADMIN']);

    // Gestion des notifications
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::patch('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::patch('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);
});

Route::post('/missions/{mission}/confirm-completion', [MissionController::class, 'confirmCompletion'])
    ->middleware(['auth:sanctum', 'role:CLIENT']);