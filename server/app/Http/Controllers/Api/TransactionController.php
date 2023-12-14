<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreDetailTransactionRequest;
use App\Models\Transaction;
use App\Http\Requests\StoreTransactionRequest;
use App\Http\Requests\UpdateTransactionRequest;
use App\Http\Resources\DetailTransactionResource;
use App\Http\Resources\TransactionResource;
use App\Models\Car;
use App\Models\Cart;
use App\Models\DetailTransaction;


class TransactionController extends Controller
{

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return TransactionResource::collection(Transaction::with(
            ['verifiedBy', 'user', 'detailTransactions' => ['car' => ['fuel', 'bodyType', 'brand']]]
        )->get());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreTransactionRequest $request)
    {
        if ($request->validated()) {
            $path = $request->file('payment_proof')->store('images/payment_proofs', 'public');
            $file_name = explode('/', $path)[2];
            $validated = $request->safe()->merge(['payment_proof' => $file_name]);

            // create transaction for detail transaction reference
            $transaction = Transaction::create($validated->all());

            // loops user carts and store to detail transaction
            $user_id = $request->user_id;
            $carts = Cart::where('user_id', $user_id)->get();
            foreach ($carts as $cart) {
                $car = Car::find($cart->car_id);
                DetailTransaction::create([
                    'transaction_id' => $transaction->id,
                    'car_id' => $cart->car_id,
                    'qty' => $cart->quantity,
                    'car_price' => $car->price,
                    'subtotal' => $cart->quantity * $car->price
                ]);
            }

            // update transaction total
            $total = DetailTransaction::where('transaction_id', $transaction->id)->sum('subtotal');
            $transaction->update(['total' => $total]);

            // delete all user cart after transaction
            $user_id = $request->user_id;
            Cart::where('user_id', $user_id)->delete();
            return response()->json(['message' => 'Transaction success'], 201);
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

                /**
                 * Used for admin to verify transaction
                 * WARNING: MIGHT BE BUGGY
                 */
            } else {
                return new TransactionResource(tap($transaction)->update($request->validated()));
            }
            // return response()->json(['message' => 'Image not found'], 400);
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
