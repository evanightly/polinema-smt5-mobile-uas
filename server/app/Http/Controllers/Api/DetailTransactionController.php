<?php

namespace App\Http\Controllers\Api;

use App\Models\DetailTransaction;
use App\Http\Requests\StoreDetailTransactionRequest;
use App\Http\Requests\UpdateDetailTransactionRequest;
use App\Http\Resources\DetailTransactionResource;
use App\Models\Transaction;

class DetailTransactionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // DetailTransaction::with(['transaction', 'car'])->get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreDetailTransactionRequest $request)
    {
        return new DetailTransactionResource(DetailTransaction::create($request->validated()));
    }

    /**
     * Display the specified resource.
     */
    public function show(DetailTransaction $detailTransaction)
    {
        // intended to use with cart after item modified
        return new DetailTransactionResource($detailTransaction);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateDetailTransactionRequest $request, DetailTransaction $detailTransaction)
    {
        return new DetailTransactionResource(tap($detailTransaction)->update($request->validated()));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(DetailTransaction $detailTransaction)
    {
        $detailTransaction->delete();
        return response()->noContent();
    }
}
