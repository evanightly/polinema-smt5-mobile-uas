@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Users</h1>
        <a href="{{ route('users.create') }}" class="btn btn-md btn-primary">Add User</a>
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
                    <td>
                        <div class="flex items-center gap-5">
                            <div class="avatar">
                                <div class="w-12 rounded-full">
                                    <img src="{{ $user->imageUrl }}" alt="{{ $user->name }}'Photo">
                                </div>
                            </div>
                            <p>{{ $user->name }}</p>
                        </div>
                    </td>
                    <td>{{ $user->email }}</td>
                    <td>{{ $user->joinedAt }}</td>
                    <td>
                        <div class="flex gap-3">
                            <a href="{{ route('users.edit', [$user]) }}" class="btn btn-primary"><i
                                    class="fa-solid fa-pen-to-square"></i></a>
                            <form action="{{ route('users.destroy', [$user->id]) }}" method="post">
                                @csrf
                                @method('DELETE')
                                <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                            </form>
                        </div>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
