<?php

namespace App\Http\Controllers;

use App\Models\Car;
use App\Http\Requests\StoreCarRequest;
use App\Http\Requests\UpdateCarRequest;
use App\Http\Resources\CarBodyTypeResource;
use App\Http\Resources\CarBrandResource;
use App\Http\Resources\CarFuelResource;
use App\Http\Resources\CarResource;
use App\Models\CarBodyType;
use App\Models\CarBrand;
use App\Models\CarFuel;
use Illuminate\Support\Facades\File;

class CarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $collection = CarResource::collection(Car::latest()->paginate(10));
        $meta = $collection->response()->getData(true)['meta'];
        return view('cars.index', [
            'cars' => $collection,
            'meta' => $meta
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('cars.create', [
            'brands' => CarBrandResource::collection(CarBrand::all()),
            'body_types' => CarBodyTypeResource::collection(CarBodyType::all()),
            'fuels' => CarFuelResource::collection(CarFuel::all()),
        ]);
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

            $newCar = new CarResource(Car::create($validated->all()));
            return redirect()->route('cars.index')->with('success', "$newCar->name has been created");
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Car $car)
    {
        return view('cars.show', [
            'car' => new CarResource($car)
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Car $car)
    {
        return view('cars.edit', [
            'car' => new CarResource($car),
            'brands' => CarBrandResource::collection(CarBrand::all()),
            'body_types' => CarBodyTypeResource::collection(CarBodyType::all()),
            'fuels' => CarFuelResource::collection(CarFuel::all()),
        ]);
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

            $newCar = new CarResource(tap($car)->update($validated->all()));
            return redirect()->route('cars.index')->with('success', "$newCar->name has been updated");
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Car $car)
    {
        File::delete(public_path('storage/images/cars/' . $car->image));
        $car->delete();
        return redirect()->route('cars.index')->with('success', "$car->name has been deleted");
    }
}
