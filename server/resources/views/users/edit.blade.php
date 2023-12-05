@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Edit User - {{ $user->name }}</h2>
        <form action="{{ route('users.update', [$user]) }}" method="post" class="flex flex-col gap-5"
            enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required
                    value="{{ $user->name }}" />
            </div>
            <div class="flex flex-1 gap-12">
                <div class="form-control flex-1">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="email" placeholder="Email" name="email" class="input" required
                        value="{{ $user->email }}" />
                </div>
                <div class="form-control flex-1">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="password" placeholder="Password" name="password" class="input" required
                        value="{{ $user->password }}" />
                </div>
            </div>
            <div class="form-control">
                <label for="address" class="label">Address</label>
                <input id="address" type="text" placeholder="Address" name="address" class="input"
                    value="{{ $user->address }}" />
            </div>
            <div class="form-control">
                <label for="image" class="label">User Picture</label>
                <input id="image" type="file" name="image" class="file-input" placeholder="User Picture" />
            </div>
            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Edit User</button>
            </div>
        </form>
    </div>
@endsection
