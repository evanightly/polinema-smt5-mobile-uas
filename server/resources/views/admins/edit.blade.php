@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Edit Admin - {{ $admin->name }}</h2>
        <form action="{{ route('admins.update', [$admin]) }}" method="post" class="flex flex-col gap-5"
            enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required
                    value="{{ $admin->name }}" />
            </div>
            <div class="flex flex-1 gap-12">
                <div class="form-control flex-1">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="email" placeholder="Email" name="email" class="input" required
                        value="{{ $admin->email }}" />
                </div>
                <div class="form-control flex-1">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="password" placeholder="Password" name="password" class="input" required
                        value="{{ $admin->password }}" />
                </div>
            </div>
            <div class="form-control flex flex-row items-center gap-3">
                <label for="isSuperAdmin" class="label">Super Admin</label>
                <input id="isSuperAdmin" type="checkbox" name="isSuperAdmin" class="checkbox checkbox-primary"
                    {{ $admin->isSuperAdmin ? 'checked' : '' }} />
            </div>
            <div class="form-control">
                <label for="image" class="label">Employee Picture</label>
                <input id="image" type="file" name="image" class="file-input" placeholder="Employee Picture" />
            </div>
            <div class="form-control">
                <button type="submit" class="btn btn-primary w-fit">Edit Admin</button>
            </div>
        </form>
    </div>
@endsection
