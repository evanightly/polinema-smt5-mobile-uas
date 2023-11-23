<?php

use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\CarBodyTypeController;
use App\Http\Controllers\Api\CarBrandController;
use App\Http\Controllers\Api\CarController;
use App\Http\Controllers\Api\CarFuelController;
use App\Http\Controllers\Api\DetailTransactionController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\UserAuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Middleware\Authenticate;
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
Route::post('/user/login', [UserAuthController::class, 'login']);
Route::post('/user/register', [UserAuthController::class, 'register']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/user/logout', [UserAuthController::class, 'logout']);

    Route::apiResource('cars', CarController::class);
    Route::apiResource('users', UserController::class);
    Route::apiResource('car-body-types', CarBodyTypeController::class);
    Route::apiResource('car-brands', CarBrandController::class);
    Route::apiResource('car-fuels', CarFuelController::class);
    Route::apiResource('transactions', TransactionController::class);
    Route::apiResource('detail-transactions', DetailTransactionController::class);
    Route::apiResource('admins', AdminController::class);
})->withoutMiddleware([Authenticate::class]);
