@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="container">
        <div class="flex items-center gap-5">
            <h1 class="text-2xl font-bold">Admins</h1>
            <a href="{{ url('admin/create') }}" class="btn btn-md btn-primary">Add Admin</a>
        </div>
        <table class="table table-zebra">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Joined At</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                @foreach ($admins as $admin)
                    <tr>
                        <td class="flex gap-5 items-center">
                            <div class="avatar">
                                <div class="w-12 rounded-full">
                                    <img src="{{ $admin->image }}" alt="{{ $admin->name }}'Photo">
                                </div>
                            </div>
                            <p>{{ $admin->name }}</p>
                        </td>
                        <td>{{ $admin->email }}</td>
                        <td>
                            @if ($admin->isSuperAdmin)
                                <span class="badge badge-primary">Super Admin</span>
                            @else
                                <span class="badge badge-secondary">Admin</span>
                            @endif

                        </td>
                        <td>{{ $admin->created }}</td>
                        <td>
                            <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                            <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
@endsection
