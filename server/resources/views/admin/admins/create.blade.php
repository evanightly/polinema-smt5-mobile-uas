@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="bg-base-200 rounded-lg p-5">
        <h2 class="text-2xl font-bold mb-5">Add Admin</h2>
        <form action="{{ url('admins') }}" method="post">
            @csrf
            <div class="form-control">
                <label for="name" class="label">Name</label>
                <input id="name" type="text" placeholder="Name" name="name" class="input" required />
            </div>
            <div class="form-control">
                <label for="email" class="label">Email</label>
                <input id="email" type="email" placeholder="Email" name="email" class="input" required />
            </div>
            <div class="form-control">
                <label for="password" class="label">Password</label>
                <input id="password" type="password" placeholder="Password" name="password" class="input" required />
            </div>
            <div class="form-control flex flex-row items-center gap-3">
                <label for="isSuperAdmin" class="label">Super Admin</label>
                <input id="isSuperAdmin" type="checkbox" checked="checked" class="checkbox checkbox-primary" required />
            </div>
            <div class="form-control">
                <label for="file" class="label">File input</label>
                <input id="file" type="file" class="file-input" placeholder="Employee Picture" required />
            </div>

            <div class="form-control">
                <button type="submit" class="btn btn-primary">Add Admin</button>
            </div>

        </form>
    </div>
@endsection
