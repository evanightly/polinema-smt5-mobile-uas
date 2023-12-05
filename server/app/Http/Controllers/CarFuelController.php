<?php

namespace App\Http\Controllers;

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
        return view('car_fuels.index', [
            'carFuels' => CarFuelResource::collection(CarFuel::all())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('car_fuels.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarFuelRequest $request)
    {
        $newCarFuel = new CarFuelResource(CarFuel::create($request->validated()));
        return redirect()->route('car-fuels.index')->with('success', "Car fuel $newCarFuel->name created successfully");
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
        return view('car_fuels.edit', [
            'carFuel' => new CarFuelResource($carFuel)
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarFuelRequest $request, CarFuel $carFuel)
    {
        $carFuel->update($request->validated());
        return redirect()->route('car-fuels.index')->with('success', "Car fuel updated successfully");
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarFuel $carFuel)
    {
        $carFuel->delete();
        return redirect()->route('car-fuels.index')->with('success', "Car fuel $carFuel->name deleted successfully");
    }
}
