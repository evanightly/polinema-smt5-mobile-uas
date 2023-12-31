<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Car;
use App\Models\DetailTransaction;


class TransactionController extends Controller
{

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view('transactions.index', [
            'transactions' => TransactionResource::collection(Transaction::with(['user', 'verifiedBy'])->latest()->get())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreTransactionRequest $request)
    {
        try {
            $defaultStockThreshold = 2;
            $userId = $request->user_id;
            $carId = $request['car']['id'];

            // search user transaction with status 'OnGoing'
            $userTransaction = Transaction::where('user_id', $userId)->where('status', 'OnGoing')->first();
            if ($userTransaction) {
                /**
                 * Update detail transaction with the selected car, and check if the selected car is exist in detail transaction,
                 * - if it exist, check the car stock if more than 1, if it is, then update the detail transaction qty and decrease the car stock
                 * - if not exist, check the car stock if more than 1, if it is, then create new detail transaction and decrease the car stock
                 */

                $detailTransaction = DetailTransaction::where(['transaction_id' => $userTransaction->id, 'car_id' => $carId])->first();
                $selectedCar = Car::where('id', $carId)->first();
                if ($detailTransaction) {
                    // dump('Car already exist in detail transaction', $detailTransaction);
                    if ($selectedCar->stock > $defaultStockThreshold) {
                        $selectedCar->update(['stock' => $selectedCar->stock - 1]);
                        // update transaction with the selected car
                        $detailTransaction->update(['qty' => $detailTransaction->qty + 1]);
                    } else {
                        return response()->json([
                            'message' => 'Stock is not enough'
                        ], 400);
                    }
                } else {
                    // dump('Car not exist in detail transaction', $detailTransaction);
                    if ($selectedCar->stock > $defaultStockThreshold) {
                        $selectedCar->update(['stock' => $selectedCar->stock - 1]);
                        // create new detail transaction with the selected car
                        $detailTransaction = DetailTransaction::create([
                            'transaction_id' => $userTransaction->id,
                            'car_id' => $carId,
                            'qty' => 1,
                            'car_price' => $selectedCar->price,
                            'subtotal' => $selectedCar->price
                        ]);

                        $total = $userTransaction->total + $selectedCar->price;

                        // update transaction with the selected car, append the detail transaction to
                        $userTransaction->update(['total' => $total]);
                    } else {
                        return response()->json([
                            'message' => 'Stock is not enough'
                        ], 400);
                    }
                }
            } else {
                $selectedCar = Car::where('id', $request->car)->first();
                if ($selectedCar->stock > $defaultStockThreshold) {
                    $selectedCar->update(['stock' => $selectedCar->stock - 1]);
                    $transaction = Transaction::create($request->validated() + ['user_id' => $userId] + ['total' => $selectedCar->price]);
                    $transactionId = $transaction->id;

                    $detailTransaction = DetailTransaction::create([
                        'transaction_id' => $transactionId,
                        'car_id' => $selectedCar->id,
                        'car_price' => $selectedCar->price,
                        'qty' => 1,
                        'subtotal' => $selectedCar->price
                    ]);

                    $total = $transaction->total + $selectedCar->price;
                } else {
                    return response()->json([
                        'message' => 'Stock is not enough'
                    ], 400);
                }
            }

            return response()->json([
                'message' => 'Added to cart'
            ], 200);
        } catch (\Throwable $th) {
        }

        // if ($userTransaction) {
        //     $userTransaction->update(['status' => 'Canceled']);
        // }
        // $transaction = Transaction::create($request->validated());
        // return $transaction;

        // return Transaction::create($request->validated());
    }

    /**
     * Display the specified resource.
     */
    public function show(Transaction $transaction)
    {
        return $transaction->load(['user', 'verifiedBy']);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Transaction $transaction)
    {
        return view('transactions.edit', [
            'transaction' => new TransactionResource($transaction)
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateTransactionRequest $request, Transaction $transaction)
    {
        $transaction->update($request->validated());
        return redirect()->route('transactions.edit', $transaction->id)->with('success', 'Transaction updated.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Transaction $transaction)
    {
        return $transaction->delete();
    }
}
