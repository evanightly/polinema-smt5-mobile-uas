<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreDetailTransactionRequest;
use App\Models\Transaction;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\DetailTransactionResource;
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
        return TransactionResource::collection(Transaction::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreTransactionRequest $request)
    {
        // ONLY FOR USER TRANSACTION
        try {
            if ($request->validated()) {
                dump($qty = $request->qty);
                // Check if qty is 0, then delete detail transaction, then check if its only one detail transaction, if so, then delete transaction
                if ($qty < 1) {
                    $detail_transaction = DetailTransaction::where('transaction_id', $request->transaction_id)
                        ->where('car_id', $request->car_id)->first();
                    $detail_transaction->delete();

                    $transaction = Transaction::find($request->transaction_id);

                    // Check if transaction only have one detail transaction, then delete transaction
                    if (count($transaction->detailTransaction) == 0) {
                        $transaction->delete();
                    }
                    return response()->json(['message' => 'Transaction success'], 201);
                }

                // Check if user already have transaction
                $transaction = Transaction::where('user_id', $request->user_id)->first();
                $car = Car::find($request->car_id);
                if ($transaction) {
                    // dump('transaction exists');

                    // Check if detail transaction with current car exists in user transaction
                    $detail_transaction = DetailTransaction::where('transaction_id', $transaction->id)
                        ->where('car_id', $request->car_id)->first();

                    // dump(empty($detail_transaction));
                    if (!empty($detail_transaction)) {

                        // check if $detail_transaction is empty
                        // if (empty($detail_transaction)) {
                        //     // dump('detail transaction is empty');
                        //     // Create new detail transaction and append it into transaction
                        //     $detail_transaction = DetailTransaction::create([
                        //         'transaction_id' => $transaction->id,
                        //         'car_id' => $request->car_id,
                        //         'car_price' => $car->price,
                        //         'qty' => $qty,
                        //         'subtotal' => $car->price * $qty
                        //     ]);

                        //     return response()->json(['message' => 'Transaction success'], 201);
                        // }

                        // dump('detail transaction exists');
                        // Update detail transaction
                        $calculated_subtotal = $car->price * $qty;
                        $updated_qty = $detail_transaction->qty + $qty;
                        $updated_subtotal = $detail_transaction->subtotal + $calculated_subtotal;
                        $updated_total = $transaction->total + $calculated_subtotal;
                        $detail_transaction->update(['qty' => $updated_qty, 'subtotal' => $updated_subtotal]);

                        // Update transaction
                        $transaction->update(['total' => $updated_total]);
                        return response()->json(['message' => 'Transaction success'], 201);
                    } else {
                        // dump('detail transaction not exists');
                        // Create new detail transaction and append it into transaction
                        $detail_transaction = DetailTransaction::create([
                            'transaction_id' => $transaction->id,
                            'car_id' => $request->car_id,
                            'car_price' => $car->price,
                            'qty' => $qty,
                            'subtotal' => $car->price * $qty

                        ]);

                        return response()->json(['message' => 'Transaction success'], 201);
                    }
                } else {
                    // dump('transaction not exists');

                    // Subtotal, because this is the first transaction
                    $subtotal = $car->price * $qty;

                    $transaction = Transaction::create([
                        'user_id' => $request->user_id,
                        'total' => $subtotal
                    ]);

                    $detail_transaction = DetailTransaction::create([
                        'transaction_id' => $transaction->id,
                        'car_id' => $request->car_id,
                        'car_price' => $car->price,
                        'qty' => $qty,
                        'subtotal' => $subtotal
                    ]);

                    return response()->json(['message' => 'Transaction success'], 201);
                }
            }
        } catch (\Throwable $th) {
            dump($th);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Transaction $transaction)
    {
        return new TransactionResource($transaction);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateTransactionRequest $request, Transaction $transaction)
    {
        // ONLY FOR USER TRANSACTION
        try {
            dump($request->payment_method);
            // get all request body data
            // return($request->all());
            if ($request->hasFile('payment_proof')) {
                $image = $request->file('payment_proof')->store('images/payment_proof', 'public');
                $image_name = explode('/', $image)[2];

                return $transaction->update([
                    'payment_proof' => $image_name,
                    'payment_method' => $request->payment_method,
                    'payment_date' => date('Y-m-d H:i:s'),
                    'delivery_address' => $request->delivery_address,
                    'status' => 'Pending'
                ]);
            }
            return response()->json(['message' => 'Image not found'], 400);
        } catch (\Throwable $th) {
            dump($th);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Transaction $transaction)
    {
        $transaction->delete();
        return response()->noContent();
    }
}
