@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Edit Car - {{ $car->name }}</h2>
        <form action="{{ route('cars.update', [$car]) }}" method="post" class="flex flex-col gap-5"
            enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required
                    value="{{ $car->name }}" />
            </div>
            <div class="flex flex-1 gap-12">
                <div class="form-control flex-1">
                    <label for="brand_id" class="label">Brand</label>
                    <select name="brand_id" id="brand_id" class="select" required>
                        @foreach ($brands as $brand)
                            <option value="{{ $brand->id }}" {{ $car->brand_id === $brand->id ? 'selected' : '' }}>
                                {{ $brand->name }}</option>
                        @endforeach
                    </select>
                </div>
                <div class="form-control flex-1">
                    <label for="body_type_id" class="label">Body Type</label>
                    <select name="body_type_id" id="body_type_id" class="select" required>
                        @foreach ($body_types as $body_type)
                            <option value="{{ $body_type->id }}" {{ $car->body_type_id === $body_type->id ? 'selected' : '' }}>
                                {{ $body_type->name }}</option>
                        @endforeach
                    </select>
                </div>
                <div class="form-control flex-1">
                    <label for="fuel_id" class="label">Fuel</label>
                    <select name="fuel_id" id="fuel_id" class="select" required>
                        @foreach ($fuels as $fuel)
                            <option value="{{ $fuel->id }}" {{ $car->fuel_id === $fuel->id ? 'selected' : '' }}>
                                {{ $fuel->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <div class="flex gap-12">
                <div class="form-control flex-1">
                    <label for="year" class="label">Year</label>
                    <input id="year" type="number" placeholder="Year" name="year" class="input" maxlength="4"
                        value="{{ $car->year }}" required />
                </div>

                <div class="form-control flex-1">
                    <label for="mileage" class="label">Mileage (Km)</label>
                    <input id="mileage" type="number" placeholder="Km Max" name="mileage" class="input"
                        value="{{ $car->mileage }}" required />
                </div>

                <div class="form-control flex-1">
                    <label for="stock" class="label">Stock</label>
                    <input id="stock" type="number" placeholder="Stock" name="stock" class="input"
                        value="{{ $car->stock }}" required />
                </div>

                <div class="form-control flex-1">
                    <label for="price" class="label">Price</label>
                    <input id="price" type="number" placeholder="Price" name="price" class="input"
                        value="{{ $car->price }}" required />
                </div>
            </div>

            <div class="form-control">
                <label for="description" class="label">Description</label>
                <textarea id="description" type="text" placeholder="Description" name="description" class="textarea">{{ $car->description }}</textarea>
            </div>

            <div class="flex gap-12">
                <div class="form-control flex-1">
                    <label for="transmission" class="label">Transmission</label>
                    <select name="transmission" id="transmission" class="select" required>
                        <option value="Manual" {{ $car->transmission === 'Manual' ? 'selected' : '' }}>Manual</option>
                        <option value="Automatic" {{ $car->transmission === 'Automatic' ? 'selected' : '' }}>Automatic
                        </option>
                    </select>
                </div>

                <div class="form-control flex-1">
                    <label for="condition" class="label">Condition</label>
                    <select name="condition" id="condition" class="select" required>
                        <option value="New" {{ $car->condition === 'New' ? 'selected' : '' }}>New</option>
                        <option value="Used" {{ $car->condition === 'Used' ? 'selected' : '' }}>Used</option>
                    </select>
                </div>

            </div>

            <div class="form-control">
                <label for="image" class="label">Car Picture</label>
                <input id="image" type="file" name="image" class="file-input" placeholder="Car Picture"
                    value="{{ $car->image }}" />
            </div>

            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Edit Car</button>
            </div>
        </form>
    </div>
@endsection
