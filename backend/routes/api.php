<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\ContentController;
use App\Http\Controllers\Api\V1\FavoriteController;
use App\Http\Controllers\Api\V1\RecipeController;
use App\Http\Controllers\Api\V1\VarietyController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->name('api.v1.')->group(function () {
    // Authentication (public)
    Route::post('/auth/register', [AuthController::class, 'register'])->name('auth.register');
    Route::post('/auth/login', [AuthController::class, 'login'])->name('auth.login');
    Route::post('/auth/guest', [AuthController::class, 'guest'])->name('auth.guest');
    Route::post('/auth/social', [AuthController::class, 'social'])->name('auth.social');

    // Catalogue (public, read-only)
    Route::get('/varieties', [VarietyController::class, 'index'])->name('varieties.index');
    Route::get('/varieties/{variety}', [VarietyController::class, 'show'])->name('varieties.show');

    Route::get('/recipes', [RecipeController::class, 'index'])->name('recipes.index');
    Route::get('/recipes/{recipe}', [RecipeController::class, 'show'])->name('recipes.show');

    Route::get('/nutrition', [ContentController::class, 'nutrition'])->name('nutrition');
    Route::get('/history', [ContentController::class, 'history'])->name('history');
    Route::get('/growing', [ContentController::class, 'growing'])->name('growing');

    // Everything in one request — handy for mobile app bootstrap / offline cache.
    Route::get('/overview', [ContentController::class, 'overview'])->name('overview');

    // Requires a Sanctum bearer token
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/auth/logout', [AuthController::class, 'logout'])->name('auth.logout');
        Route::get('/auth/user', [AuthController::class, 'user'])->name('auth.user');
        Route::put('/auth/profile', [AuthController::class, 'updateProfile'])->name('auth.profile');

        Route::get('/favorites', [FavoriteController::class, 'index'])->name('favorites.index');
        Route::post('/favorites', [FavoriteController::class, 'store'])->name('favorites.store');
        Route::delete('/favorites/{variety:id}', [FavoriteController::class, 'destroy'])->name('favorites.destroy');
    });
});
