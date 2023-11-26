<?php

namespace App\Http\Controllers\Api;

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
        return CarBodyTypeResource::collection(CarBodyType::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarBodyTypeRequest $request)
    {
        return new CarBodyTypeResource(CarBodyType::create($request->validated()));
    }

    /**
     * Display the specified resource.
     */
    public function show(CarBodyType $carBodyType)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarBodyTypeRequest $request, CarBodyType $carBodyType)
    {
        return new CarBodyTypeResource(tap($carBodyType)->update($request->validated()));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarBodyType $carBodyType)
    {
        $carBodyType->delete();
        return response()->noContent();
    }
}
