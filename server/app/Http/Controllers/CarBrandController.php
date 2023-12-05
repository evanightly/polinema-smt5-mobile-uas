<?php

namespace App\Http\Controllers;

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
        return view('car_brands.index', [
            'carBrands' => CarBrandResource::collection(CarBrand::all())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('car_brands.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarBrandRequest $request)
    {
        $newCarBrand = new CarBrandResource(CarBrand::create($request->validated()));
        return redirect()->route('car-brands.index')->with('success', "Car brand $newCarBrand->name created successfully");
    }

    /**
     * Display the specified resource.
     */
    public function show(CarBrand $carBrand)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(CarBrand $carBrand)
    {
        return view('car_brands.edit', [
            'carBrand' => new CarBrandResource($carBrand)
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarBrandRequest $request, CarBrand $carBrand)
    {
        $carBrand->update($request->validated());
        return redirect()->route('car-brands.index')->with('success', "Car brand updated successfully");
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CarBrand $carBrand)
    {
        $carBrand->delete();
        return redirect()->route('car-brands.index')->with('success', "Car brand $carBrand->name deleted successfully");
    }
}
