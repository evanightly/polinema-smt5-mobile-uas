@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5 my-8">
        <h1 class="text-2xl font-bold">Cars</h1>
        <a href="{{ url('cars/create') }}" class="btn btn-md btn-primary">Add Car</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Image</th>
                <th>Name</th>
                <th>Brand</th>
                <th>Body Type</th>
                <th>Year</th>
                <th>Speed</th>
                <th>Fuel</th>
                <th>Price</th>
                <th>Condition</th>
                <th>Transmission</th>
                <th>Status</th>
                <th>Description</th>
                <th>Stock</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($cars as $car)
                <tr>
                    <td class="flex gap-5 items-center">
                        <div class="avatar">
                            <div class="w-32 h-20">
                                <img src="{{ $car->image }}" alt="{{ $car->name }}'Photo">
                            </div>
                        </div>
                    </td>
                    <td>
                        <p>{{ $car->name }}</p>
                    </td>
                    <td>{{ $car->brand->name }}</td>
                    <td>{{ $car->bodyType->name }}</td>
                    <td>{{ $car->year }}</td>
                    <td>0 - {{ $car->km_max }} Km</td>
                    <td>{{ $car->fuel->name }}</td>
                    <td>{{ $car->price }}</td>
                    <td>{{ $car->condition }}</td>
                    <td>{{ $car->transmission }}</td>
                    <td>{{ $car->status }}</td>
                    <td>{{ $car->description }}</td>
                    <td>{{ $car->stock }}</td>
                    <td>
                        <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
