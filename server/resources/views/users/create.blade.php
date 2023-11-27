@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Add User</h2>
        <form action="{{ route('users.store') }}" method="post" class="flex flex-col gap-5" enctype="multipart/form-data">
            @csrf
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input"
                    value="{{ old('name') }}" required />
            </div>
            <div class="flex flex-1 gap-12">
                <div class="form-control flex-1">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="email" placeholder="Email" name="email" class="input"
                        value="{{ old('email') }}" required />
                </div>
                <div class="form-control flex-1">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="password" placeholder="Password" name="password" class="input"
                        value="{{ old('password') }}" required />
                </div>
            </div>
            <div class="form-control">
                <label for="address" class="label">Address</label>
                <input id="address" type="text" placeholder="Address" name="address" class="input"
                    value="{{ old('address') }}" />
            </div>
            <div class="form-control">
                <label for="image" class="label">User Picture</label>
                <input id="image" type="file" name="image" class="file-input" placeholder="User Picture"
                    value="{{ old('image') }}" required />
            </div>
            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Add User</button>
            </div>
        </form>
    </div>
@endsection
