<?php

namespace App\Http\Controllers\Api;

use App\Models\CarBrand;
use App\Http\Requests\StoreCarBrandRequest;
use App\Http\Requests\UpdateCarBrandRequest;
use App\Http\Resources\CarBrandResource;

class CarBrandController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return CarBrandResource::collection(CarBrand::with([
            'cars' => [
                'fuel',
                'bodyType',
                'brand'
            ],
        ])->get());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarBrandRequest $request)
    {
        return new CarBrandResource(CarBrand::create($request->validated()));
    }

    /**
     * Display the specified resource.
     */
    public function show(CarBrand $carBrand)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarBrandRequest $request, CarBrand $carBrand)
    {
        return new CarBrandResource(tap($carBrand)->update($request->validated()));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarBrand $carBrand)
    {
        $carBrand->delete();
        return response()->noContent();
    }
}
