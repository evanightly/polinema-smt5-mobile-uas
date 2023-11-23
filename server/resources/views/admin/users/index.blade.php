@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5 my-8">
        <h1 class="text-2xl font-bold">Users</h1>
        <a href="{{ url('users/create') }}" class="btn btn-md btn-primary">Add User</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Joined At</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($users as $user)
                <tr>
                    <td class="flex gap-5 items-center">
                        <div class="avatar">
                            <div class="w-12 rounded-full">
                                <img src="{{ $user->image }}" alt="{{ $user->name }}'Photo">
                            </div>
                        </div>
                        <p>{{ $user->name }}</p>
                    </td>
                    <td>{{ $user->email }}</td>
                    <td>{{ $user->created }}</td>
                    <td>
                        <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
