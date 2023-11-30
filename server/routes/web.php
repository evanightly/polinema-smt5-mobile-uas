<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\AdminDashboardController;
use App\Http\Controllers\CarBodyTypeController;
use App\Http\Controllers\CarBrandController;
use App\Http\Controllers\CarController;
use App\Http\Controllers\CarFuelController;
use App\Http\Controllers\DetailTransactionController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// Route::get('/login', [AdminAuthController::class, 'index'])->name('login');
// Route::post('/login', [AdminAuthController::class, 'login']);

// Route::post('/logout', [AdminAuthController::class, 'logout']);

Route::middleware(['auth'])->group(function () {
    Route::get('/', [AdminDashboardController::class, 'index']);
    Route::resource('cars', CarController::class);
    Route::resource('users', UserController::class);
    Route::resource('car-body-types', CarBodyTypeController::class);
    Route::resource('car-brands', CarBrandController::class);
    Route::resource('car-fuels', CarFuelController::class);
    Route::resource('transactions', TransactionController::class);
    Route::resource('detail-transactions', DetailTransactionController::class);
    Route::resource('admins', AdminController::class);
});
