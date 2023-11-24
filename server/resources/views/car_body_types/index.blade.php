@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5 my-8">
        <h1 class="text-2xl font-bold">Car Body Type</h1>
        <a href="{{ url('car-body-types/create') }}" class="btn btn-md btn-primary">Add Body Type</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($carBodyTypes as $bodyType)
                <tr>
                    <td>{{ $bodyType->name }}</td>
                    <td>
                        <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
