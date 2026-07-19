<?php

use App\Http\Controllers\PageController;
use Illuminate\Support\Facades\Route;

Route::get('/', [PageController::class, 'home'])->name('home');
Route::get('/varieties', [PageController::class, 'varieties'])->name('varieties');
Route::get('/nutrition', [PageController::class, 'nutrition'])->name('nutrition');
Route::get('/recipes', [PageController::class, 'recipes'])->name('recipes');
Route::get('/history', [PageController::class, 'history'])->name('history');
Route::get('/growing', [PageController::class, 'growing'])->name('growing');
