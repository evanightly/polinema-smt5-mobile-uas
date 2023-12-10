<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\SearchCarRequest;
use App\Models\Car;
use App\Http\Requests\StoreCarRequest;
use App\Http\Requests\UpdateCarRequest;
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
        return CarResource::collection(Car::with(['brand', 'bodyType', 'fuel'])->latest()->paginate(5));
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
    public function search(SearchCarRequest $request)
    {
        if ($request->validated()) {
            /**
             * Search car by:
             * min_price
             * max_price
             * min_km
             * max_km
             * min_year
             * max_year
             * brand_id
             * car_body_type_id
             * transmission
             * condition
             */

            $min_price = $request->min_price;
            $max_price = $request->max_price;
            $min_km = $request->min_km;
            $max_km = $request->max_km;
            $min_year = $request->min_year;
            $max_year = $request->max_year;
            $brand_id = $request->brand_id;
            $body_type_id = $request->body_type_id;
            $transmission = $request->transmission;
            $condition = $request->condition;

            // filter, but check if the specific field is not null
            $cars = CarResource::collection(
                Car::all()
                    ->when($min_price, fn ($query, $min_price) => $query->where('price', '>=', $min_price))
                    ->when($max_price, fn ($query, $max_price) => $query->where('price', '<=', $max_price))
                    ->when($min_km, fn ($query, $min_km) => $query->where('mileage', '>=', $min_km))
                    ->when($max_km, fn ($query, $max_km) => $query->where('mileage', '<=', $max_km))
                    ->when($min_year, fn ($query, $min_year) => $query->where('year', '>=', $min_year))
                    ->when($max_year, fn ($query, $max_year) => $query->where('year', '<=', $max_year))
                    ->when($brand_id, fn ($query, $brand_id) => $query->where('brand_id', $brand_id))
                    ->when($body_type_id, fn ($query, $body_type_id) => $query->where('body_type_id', $body_type_id))
                    ->when($transmission, fn ($query, $transmission) => $query->where('transmission', $transmission))
                    ->when($condition, fn ($query, $condition) => $query->where('condition', $condition))
            );

            if ($cars->isEmpty()) {
                return [];
            }

            $cars = $cars->map(function ($car) {
                return [
                    'name' => $car->name,
                    'price' => $car->price,
                    'year' => $car->year,
                    'mileage' => $car->mileage,
                    'stock' => $car->stock
                ];
            });

            /** Criteria type and its weight
             * price = Cost, 8
             * year = Benefit, 4
             * km_max = Benefit, 2
             * stock = Benefit, 2
             */

            $weight = [8, 4, 2, 2];
            $criteria = ['price', 'year', 'km_max', 'stock'];
            $criteria_type = ['cost', 'benefit', 'benefit', 'benefit'];

            function calculate_divider($cars)
            {
                $sum_price = $sum_year = $sum_mileage = $sum_stock = 0;

                $cars->map(function ($car) use (&$sum_price, &$sum_year, &$sum_mileage, &$sum_stock) {
                    $sum_price += pow($car['price'], 2);
                    $sum_year += pow($car['year'], 2);
                    $sum_mileage += pow($car['mileage'], 2);
                    $sum_stock += pow($car['stock'], 2);
                });

                return [sqrt($sum_price), sqrt($sum_year), sqrt($sum_mileage), sqrt($sum_stock)];
            };

            function calculate_normalized_matrix($cars, $calculatedDivider)
            {
                $normalized_matrix = [];

                $cars->map(function ($car) use (&$normalized_matrix, $calculatedDivider) {
                    $segment = [
                        $car['price'] / $calculatedDivider[0],
                        $car['year'] / $calculatedDivider[1],
                        $car['mileage'] / $calculatedDivider[2],
                        $car['stock'] / $calculatedDivider[3]
                    ];

                    array_push($normalized_matrix, $segment);
                });

                return $normalized_matrix;
            };

            function calculate_weighted_matrix($normalized_matrix, $weight)
            {
                $weighted_matrix = [];

                for ($i = 0; $i < count($normalized_matrix); $i++) {
                    $segment = [
                        $normalized_matrix[$i][0] * $weight[0],
                        $normalized_matrix[$i][1] * $weight[1],
                        $normalized_matrix[$i][2] * $weight[2],
                        $normalized_matrix[$i][3] * $weight[3]
                    ];

                    array_push($weighted_matrix, $segment);
                }

                return $weighted_matrix;
            };

            function calculate_ideal_solution($weighted_matrix, $criteria_type)
            {
                $ideal_solution_y_plus = [];
                $ideal_solution_y_minus = [];

                for ($i = 0; $i < count($weighted_matrix[0]); $i++) {
                    $segment = [];

                    for ($j = 0; $j < count($weighted_matrix); $j++) {
                        array_push($segment, $weighted_matrix[$j][$i]);
                    }

                    if ($criteria_type[$i] == 'cost') {
                        array_push($ideal_solution_y_plus, min($segment));
                        array_push($ideal_solution_y_minus, max($segment));
                    } else {
                        array_push($ideal_solution_y_plus, max($segment));
                        array_push($ideal_solution_y_minus, min($segment));
                    }
                }

                return [$ideal_solution_y_plus, $ideal_solution_y_minus];
            };

            function calculate_distance($ideal_solution, $weighted_matrix)
            {
                $distance_y_plus = [];
                $distance_y_minus = [];

                for ($i = 0; $i < count($weighted_matrix); $i++) {
                    $segment_y_plus = 0;
                    $segment_y_minus = 0;

                    for ($j = 0; $j < count($weighted_matrix[0]); $j++) {
                        $segment_y_plus += pow($weighted_matrix[$i][$j] - $ideal_solution[0][$j], 2);
                        $segment_y_minus += pow($weighted_matrix[$i][$j] - $ideal_solution[1][$j], 2);
                    }

                    array_push($distance_y_plus, sqrt($segment_y_plus));
                    array_push($distance_y_minus, sqrt($segment_y_minus));
                }

                return [$distance_y_plus, $distance_y_minus];
            };

            function calculate_preferable_solution($distance)
            {
                $preferable_solution = [];

                for ($i = 0; $i < count($distance[0]); $i++) {
                    array_push($preferable_solution, $distance[1][$i] / ($distance[0][$i] + $distance[1][$i]));
                }

                return $preferable_solution;
            };

            function get_car_id($calculated_preferable_solution, $cars)
            {
                $car_ids = [];
                $iterable_index = 0;

                foreach ($cars as $key => $value) {
                    array_push($car_ids, [
                        'id' => $key + 1, // because the id substracted by 1 in line 143 (not a clean way)
                        'name' => $value['name'],
                        'preferable_solution' => $calculated_preferable_solution[$iterable_index++]
                    ]);
                }

                return $car_ids;
            }

            function sortByPreferableSolution($car_ids)
            {
                usort($car_ids, function ($a, $b) {
                    return  $b['preferable_solution'] <=> $a['preferable_solution'];
                });

                return $car_ids;
            }

            function getCarResources($sorted_rank)
            {
                $car_resources = [];

                foreach ($sorted_rank as $result) {
                    $car = Car::with(['brand', 'bodyType', 'fuel'])->where('id', $result['id'])->first();
                    array_push($car_resources, new CarResource($car));
                }

                return $car_resources;
            }

            $calculated_divider = calculate_divider($cars);
            $calculated_normalized_matrix = calculate_normalized_matrix($cars, $calculated_divider);
            $calculated_weighted_matrix = calculate_weighted_matrix($calculated_normalized_matrix, $weight);
            $calculated_ideal_solution = calculate_ideal_solution($calculated_weighted_matrix, $criteria_type);
            $calculated_distance = calculate_distance($calculated_ideal_solution, $calculated_weighted_matrix);
            $calculated_preferable_solution = calculate_preferable_solution($calculated_distance);

            $car_ids = get_car_id($calculated_preferable_solution, $cars);
            $sorted_rank = sortByPreferableSolution($car_ids);
            $car_resources = getCarResources($sorted_rank);
            // dump($sorted_rank);
            return $car_resources;

            // $cars = CarResource::collection(
            //     Car::all()
            //         ->whereBetween('price', [$min_price, $max_price])
            //         ->whereBetween('km_max', [$min_km, $max_km])
            //         ->whereBetween('year', [$min_year, $max_year])
            //         ->where('brand_id', $brand_id)
            //         ->where('body_type_id', $body_type_id)
            //         ->where('transmission', $transmission)
            //         ->where('condition', $condition)
            // );
        }
    }
}
