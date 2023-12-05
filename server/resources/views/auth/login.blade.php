@extends('layouts.master')
@section('content')
    <div class="w-screen h-screen flex items-center">
        <video src="{{ asset('video/forest.mp4') }}" autoplay loop muted class="bg-blend-overlay fixed"></video>
        <div class="absolute w-screen h-screen bg-black bg-opacity-50"></div>
        <div class="w-2/6 mx-auto rounded-lg shadow-md z-10 bg-base-100 bg-opacity-80 py-12">
            <div class="flex flex-col text-center mb-12 gap-3">
                <h1 class="text-3xl font-bold">Welcome</h1>
                <p>Please fill the details below</p>
            </div>

            <form action="{{ route('login') }}" method="POST" class="flex flex-1 flex-col px-16">
                @csrf
                <div class="mb-4">
                    <label for="email" class="label">Email</label>
                    <input id="email" type="email" name="email" class="input w-full" value="{{ old('email') }}"
                        required />
                </div>
                <div class="mb-4">
                    <label for="password" class="label">Password</label>
                    <input id="password" type="password" name="password" class="input w-full" value="{{ old('password') }}"
                        required />
                </div>
                <div class="mb-4 flex gap-5 items-center">
                    <label for="remember" class="cursor-pointer label">
                        Remember me
                    </label>
                    <input id="remember" type="checkbox" name="remember" class="checkbox" />
                </div>
                <button type="submit" class="btn btn-primary mt-5">Login</button>
            </form>
        </div>
    </div>
@endsection
