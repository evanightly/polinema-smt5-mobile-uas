<?php

use App\Http\Controllers\AdminAuthController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\CarBodyTypeController;
use App\Http\Controllers\CarBrandController;
use App\Http\Controllers\CarController;
use App\Http\Controllers\CarFuelController;
use App\Http\Controllers\DetailTransactionController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\UserAuthController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\Authenticate;
use App\Models\DetailTransaction;
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
Route::post('/user/login', [UserAuthController::class, 'login']);
Route::post('/user/register', [UserAuthController::class, 'register']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/admin/logout', [AdminAuthController::class, 'logout']);
    Route::post('/user/logout', [UserAuthController::class, 'logout']);

    Route::resource('cars', CarController::class);
    Route::resource('users', UserController::class);
    Route::resource('car-body-types', CarBodyTypeController::class);
    Route::resource('car-brands', CarBrandController::class);
    Route::resource('car-fuels', CarFuelController::class);
    Route::resource('transactions', TransactionController::class);
    Route::resource('detail-transactions', DetailTransactionController::class);
    Route::resource('admins', AdminController::class);
})->withoutMiddleware([Authenticate::class]);
