@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Add Car Fuel</h2>
        <form action="{{ route('car-fuels.store') }}" method="post" class="flex flex-col gap-5" enctype="multipart/form-data">
            @csrf
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required />
            </div>
            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Add Car Fuel</button>
            </div>
        </form>
    </div>
@endsection
