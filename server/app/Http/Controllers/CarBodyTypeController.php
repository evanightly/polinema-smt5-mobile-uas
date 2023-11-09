<?php

namespace App\Http\Controllers;

use App\Models\CarBodyType;
use App\Http\Requests\StoreCarBodyTypeRequest;
use App\Http\Requests\UpdateCarBodyTypeRequest;

class CarBodyTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return CarBodyType::all();
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
    public function store(StoreCarBodyTypeRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(CarBodyType $carBodyType)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(CarBodyType $carBodyType)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarBodyTypeRequest $request, CarBodyType $carBodyType)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarBodyType $carBodyType)
    {
        //
    }
}
