<?php

namespace App\Http\Controllers\Api;

use App\Models\CarFuel;
use App\Http\Requests\StoreCarFuelRequest;
use App\Http\Requests\UpdateCarFuelRequest;
use App\Http\Resources\CarFuelResource;

class CarFuelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return CarFuelResource::collection(CarFuel::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarFuelRequest $request)
    {
        return new CarFuelResource(CarFuel::create($request->validated()));
    }

    /**
     * Display the specified resource.
     */
    public function show(CarFuel $carFuel)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarFuelRequest $request, CarFuel $carFuel)
    {
        return new CarFuelResource(tap($carFuel)->update($request->validated()));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarFuel $carFuel)
    {
        $carFuel->delete();
        return response()->noContent();
    }
}
