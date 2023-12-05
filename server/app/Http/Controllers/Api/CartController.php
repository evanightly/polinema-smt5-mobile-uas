<?php

namespace App\Http\Controllers\Api;

use App\Models\Cart;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCartRequest;
use App\Http\Requests\UpdateCartRequest;
use App\Models\Car;

class CartController extends Controller
{
    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCartRequest $request)
    {
        // check if the user already has the car in the cart
        $cart = Cart::where('user_id', $request->user_id)
            ->where('car_id', $request->car_id)
            ->first();

        // if the car is already in the cart, update the quantity
        if ($cart) {
            $cart->update([
                'quantity' => $cart->quantity + $request->quantity,
                'subtotal' => $cart->subtotal + $request->subtotal,
            ]);
            return response()->json(['message' => 'Cart updated'], 200);
        }

        // if the car is not in the cart, calculate the subtotal, then create a new cart
        Cart::create($request->validated());

        return response()->json(['message' => 'Cart created'], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Cart $cart)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCartRequest $request, Cart $cart)
    {
        if ($request->validated()) {

            // check if the car stock is more than 1, if it is, then update the cart
            if ($request->quantity < 1) {
                $cart->delete();
                return response()->json(['message' => 'Cart deleted'], 200);
            }

            // else, update the cart
            $cart->update($request->validated());
            return response()->json(['message' => 'Cart updated'], 200);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Cart $cart)
    {
        $cart->delete();
        return response()->json(['message' => 'Cart deleted'], 204);
    }
}
