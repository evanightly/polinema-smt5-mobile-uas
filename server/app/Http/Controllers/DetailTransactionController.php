<?php

namespace App\Http\Controllers;

use App\Models\DetailTransaction;
use App\Http\Requests\StoreDetailTransactionRequest;
use App\Http\Requests\UpdateDetailTransactionRequest;
use App\Models\Transaction;

class DetailTransactionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        DetailTransaction::with(['transaction', 'car'])->get();
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
    public function store(StoreDetailTransactionRequest $request)
    {
        DetailTransaction::create($request->validated());
    }

    /**
     * Display the specified resource.
     */
    public function show(DetailTransaction $detailTransaction)
    {
        // intended to use with cart after item modified
        DetailTransaction::with(['transaction', 'car'])->find($detailTransaction->id);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(DetailTransaction $detailTransaction)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateDetailTransactionRequest $request, DetailTransaction $detailTransaction)
    {
        $transaction = Transaction::find($detailTransaction->transaction_id);
        $transaction->total = $transaction->total - $detailTransaction->total;
        $transaction->save();

        return $detailTransaction->update($request->validated());
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(DetailTransaction $detailTransaction)
    {
        return $detailTransaction->delete();
    }
}
