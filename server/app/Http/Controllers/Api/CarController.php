<?php

namespace App\Http\Controllers\Api;

use App\Models\Car;
use App\Http\Requests\StoreCarRequest;
use App\Http\Requests\UpdateCarRequest;
use App\Http\Requests\WeightedSearchCarRequest;
use App\Http\Resources\CarBrandResource;
use App\Http\Resources\CarResource;
use Illuminate\Support\Facades\File;

class CarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Display all available cars
        return CarResource::collection(Car::with(['brand', 'bodyType', 'fuel'])->latest()->get());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCarRequest $request)
    {
        if ($request->validated()) {
            $path = $request->file('image')->store('images/cars', 'public');
            $file_name = explode('/', $path)[2];
            $validated = $request->safe()->merge(['image' => $file_name]);

            return new CarResource(Car::create($validated->all()));
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Car $car)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCarRequest $request, Car $car)
    {
        if ($request->validated()) {

            $validated = $request->safe();
            // if file exists, delete it
            if ($request->hasFile('image')) {
                File::delete(public_path('storage/images/cars/' . $car->image));

                $path = $request->file('image')->store('images/cars', 'public');
                $file_name = explode('/', $path)[2];
                $validated = $request->safe()->merge(['image' => $file_name]);
            }

            return new CarResource(tap($car)->update($validated->all()));
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Car $car)
    {
        File::delete(public_path('storage/images/cars/' . $car->image));
        $car->delete();
        return response()->noContent();
    }

    /**
     * Weighted search using topsis method
     */
    public function weightedSearch(WeightedSearchCarRequest $request)
    {
        if ($request->validated()) {
            $price_weight = $request->price_weight;
            $year_weight = $request->year_weight;
            $km_max_weight = $request->km_max_weight;

            return [
                'price_weight' => $price_weight,
                'year_weight' => $year_weight,
                'km_max_weight' => $km_max_weight];

            // $cars = Car::all();
            // $cars->map(function ($car) {
            //     $car->weight = $car->weight();
            //     return $car;
            // });
            // $cars = $cars->sortByDesc('weight');
            // return view('cars.index', [
            //     'cars' => CarResource::collection($cars)
            // ]);
        }
    }
}
