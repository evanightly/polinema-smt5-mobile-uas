<?php

namespace App\Http\Controllers;

use App\Models\DetailTransaction;
use App\Http\Requests\StoreDetailTransactionRequest;
use App\Http\Requests\UpdateDetailTransactionRequest;

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
        //
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
        $detailTransaction->update($request->validated());
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(DetailTransaction $detailTransaction)
    {
        $detailTransaction->delete();
    }
}
