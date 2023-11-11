<?php

namespace App\Http\Controllers;

use App\Models\CarFuel;
use App\Http\Requests\StoreCarFuelRequest;
use App\Http\Requests\UpdateCarFuelRequest;

class CarFuelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return CarFuel::all();
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
    public function store(StoreCarFuelRequest $request)
    {
        return CarFuel::create($request->validated());
    }

    /**
     * Display the specified resource.
     */
    public function show(CarFuel $carFuel)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(CarFuel $carFuel)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarFuelRequest $request, CarFuel $carFuel)
    {
        return $carFuel->update($request->validated());
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarFuel $carFuel)
    {
        return $carFuel->delete();
    }
}
