@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="container flex flex-col gap-5">
        <div class="flex gap-14">
            <img src="{{ $car->image }}" alt="{{ $car->name }}'Photo" class="h-96">
            <div class="container flex flex-col gap-5">
                <h1 class="text-4xl">{{ $car->name }}</h1>
                <div class="columns-3 space-y-5 gap-5">
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Brand:
                        </span>
                        <p>{{ $car->brand->name }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Body Type:
                        </span>
                        <p>{{ $car->bodyType->name }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Production Year:
                        </span>
                        <p>{{ $car->year }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Speed:
                        </span>
                        <p>0 - {{ $car->km_max }} Km</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Fuel:
                        </span>
                        <p>{{ $car->fuel->name }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Price:
                        </span>
                        <p>$ {{ $car->price }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Condition:
                        </span>
                        <p>{{ $car->condition }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Transmission:
                        </span>
                        <p>{{ $car->transmission }}</p>
                    </div>
                    <div class="flex items-baseline gap-2 rounded-lg shadow-lg p-5 bg-base-200">
                        <span class="font-semibold text-lg">
                            Stock:
                        </span>
                        <p>{{ $car->stock }}</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="flex items-baseline flex-col">
            <span class="font-semibold text-lg">
                Description:
            </span>
            <p>{{ $car->description }}</p>
        </div>
    </div>
@endsection
