<?php

namespace App\Http\Controllers;

use App\Models\CarBodyType;
use App\Http\Requests\StoreCarBodyTypeRequest;
use App\Http\Requests\UpdateCarBodyTypeRequest;
use App\Http\Resources\CarBodyTypeResource;

class CarBodyTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view('car_body_types.index', [
            'carBodyTypes' => CarBodyTypeResource::collection(CarBodyType::all())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('car_body_types.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarBodyTypeRequest $request)
    {
        $newCarBodyType = new CarBodyTypeResource(CarBodyType::create($request->validated()));
        return redirect()->route('car-body-types.index')->with('success', "Car body type $newCarBodyType->name created successfully");
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
        return view('car_body_types.edit', [
            'carBodyType' => new CarBodyTypeResource($carBodyType)
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarBodyTypeRequest $request, CarBodyType $carBodyType)
    {
        $carBodyType->update($request->validated());
        return redirect()->route('car-body-types.index')->with('success', "Car body type updated successfully");
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarBodyType $carBodyType)
    {
        $carBodyType->delete();
        return redirect()->route('car-body-types.index')->with('success', "Car body type $carBodyType->name deleted successfully");
    }
}
