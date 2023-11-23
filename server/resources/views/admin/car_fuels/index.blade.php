@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5 my-8">
        <h1 class="text-2xl font-bold">Car Fuels</h1>
        <a href="{{ url('car-fuels/create') }}" class="btn btn-md btn-primary">Add Fuel</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($carFuels as $carFuel)
                <tr>
                    <td>{{ $carFuel->name }}</td>
                    <td>
                        <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
