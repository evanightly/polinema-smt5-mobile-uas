<?php

namespace App\Http\Controllers;

use App\Models\Car;
use App\Http\Requests\StoreCarRequest;
use App\Http\Requests\UpdateCarRequest;

class CarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Display all available cars
        return Car::with([
            'brand' => function ($brand) {
                $brand->select('id', 'name');
            },
            'fuel' => function ($fuel) {
                $fuel->select('id', 'name');
            },
            'bodyType' => function ($bodyType) {
                $bodyType->select('id', 'name');
            }
        ])->latest()->get();
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
    public function store(StoreCarRequest $request)
    {
        if (!$request->hasFile('image')) {
            return response()->json([
                'message' => 'Image not found'
            ], 400);
        }
        $image = $request->file('image')->store('images/cars', 'public');
        $image_name = explode('/', $image)[2];

        $car = Car::create([
            'name' => $request->name,
            'brand_id' => $request->brand_id,
            'body_type_id' => $request->body_type_id,
            'year' => $request->year,
            'km_min' => $request->km_min,
            'km_max' => $request->km_max,
            'fuel_id' => $request->fuel_id,
            'price' => $request->price,
            'image' => $image_name,
            'description' => $request->description,
            'condition' => $request->condition,
            'transmission' => $request->transmission,
            'status' => $request->status,
        ]);

        return $car;
    }

    /**
     * Display the specified resource.
     */
    public function show(Car $car)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Car $car)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarRequest $request, Car $car)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Car $car)
    {
        // delete car with its image but first check if the image exists
        if (file_exists(public_path('storage/images/cars/' . $car->image))) {
            unlink(public_path('storage/images/cars/' . $car->image));
        }
        $car->delete();
        return response()->json([
            'message' => 'Car deleted successfully'
        ], 200);
    }
}
