<?php

use App\Http\Controllers\AdminAuthController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\CarBodyTypeController;
use App\Http\Controllers\CarBrandController;
use App\Http\Controllers\CarController;
use App\Http\Controllers\CarFuelController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\Authenticate;
use App\Models\Admin;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/admin/login', [AdminAuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/admin/logout', [AdminAuthController::class, 'logout']);
    
    Route::resource('cars', CarController::class);
    Route::resource('users', UserController::class);
    Route::resource('car-body-types', CarBodyTypeController::class);
    Route::resource('car-brands', CarBrandController::class);
    Route::resource('car-fuels', CarFuelController::class);
    Route::resource('transactions', TransactionController::class);
    Route::resource('admins', AdminController::class);
})->withoutMiddleware([Authenticate::class]);
