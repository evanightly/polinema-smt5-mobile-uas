@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Edit Car Brand - {{ $carBrand->name }}</h2>
        <form action="{{ route('car-brands.update', [$carBrand]) }}" method="post" class="flex flex-col gap-5"
            enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required
                    value="{{ $carBrand->name }}" />
            </div>
            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Edit Car Brand</button>
            </div>
        </form>
    </div>
@endsection
