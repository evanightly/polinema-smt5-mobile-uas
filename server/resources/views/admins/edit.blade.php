@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="p-5 rounded-lg bg-base-200">
        <h2 class="mb-5 text-2xl font-bold">Edit Admin - {{ $admin->name }}</h2>
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
                <div class="flex-1 form-control">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="email" placeholder="Email" name="email" class="input" required
                        value="{{ $admin->email }}" />
                </div>
                <div class="flex-1 form-control">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="password" placeholder="Password" name="password" class="input" />
                </div>
            </div>
            <div class="flex flex-row items-center gap-3 form-control">
                <label for="is_super_admin" class="label">Super Admin</label>
                <input id="is_super_admin" type="checkbox" name="is_super_admin" class="checkbox checkbox-primary"
                    {{ $admin->is_super_admin ? 'checked' : '' }} />
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
