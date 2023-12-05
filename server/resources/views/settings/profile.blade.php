@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Settings</h1>
    </div>
    <div class="w-fit">
        <div role="tablist" class="tabs tabs-bordered">
            <a role="tab" class="tab tab-active">Profile</a>
            <a role="tab" class="tab ">System Settings</a>
        </div>
    </div>
    <div class="flex">
        <div class="flex-col flex-1 gap-2">
            <h2 class="text-xl">
                Personal Information
            </h2>
            <p>Add or modify your personal information</p>
        </div>

        <form action="{{ route('admins.update', [$admin]) }}" method="post" enctype="multipart/form-data" class="flex-[2]">
            @csrf
            @method('PUT')
            <div class="flex flex-col gap-5 p-5 rounded-lg bg-base-200">
                <div class="form-control">
                    <label for="name" class="label">Name</label>
                    <input id="name" type="text" name="name" class="input" value="{{ $admin->name }}">
                </div>
                <div class="form-control">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="text" name="email" class="input" value="{{ $admin->email }}">
                </div>
                <div class="form-control">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="text" name="password" class="input">
                </div>
                <div class="card bg-base-100">
                    <div class="card-body">
                        <div class="flex items-center justify-between">
                            <div class="flex flex-col gap-2">
                                <p class="text-xl">
                                    Profile Image
                                </p>
                                <p>Let your team members see your face.</p>
                            </div>
                            <div class="avatar">
                                <div class="w-24 rounded-full">
                                    <img src="{{ $admin->image_url }}" />
                                </div>
                            </div>
                        </div>
                        <label for="image" class="rounded-full btn btn-primary w-fit btn-sm">
                            <i class="fa-regular fa-image"></i>
                            Change Image
                        </label>
                        <input type="hidden" name="is_super_admin" value="{{ $admin->is_super_admin ? 'on' : null }}">
                        <input id="image" type="file" name="image"
                            class="hidden rounded-full file-input file-input-bordered">
                    </div>
                </div>
                <button type="submit" class="rounded-full btn btn-success w-fit">Save Information</button>
            </div>
        </form>
    </div>
@endsection
