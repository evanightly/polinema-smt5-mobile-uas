@extends('layouts.master')

@section('content')
    <div class="drawer lg:drawer-open">
        <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
        <div class="drawer-content flex flex-col items-center">
            <!-- Page content here -->

            <div class="navbar bg-base-100 shadow">
                <div class="flex-1">
                    <label for="my-drawer-2" class="btn btn-primary drawer-button lg:hidden">Open Sidebar</label>
                    <a class="btn btn-ghost text-xl">Dashboard</a>
                </div>
                <div class="flex-none">
                    <div class="dropdown dropdown-end">
                        <label tabindex="0" class="btn btn-ghost btn-circle avatar">
                            <div class="w-10 rounded-full">
                                <img alt="User Profile" src="/images/stock/photo-1534528741775-53994a69daeb.jpg" />
                            </div>
                        </label>
                        <ul tabindex="0"
                            class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
                            <li>
                                <a class="justify-between">
                                    Profile
                                    <span class="badge">New</span>
                                </a>
                            </li>
                            <li><a>Settings</a></li>
                            <li><a>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="container mx-auto">
                @yield('content-dashboard')
            </div>
        </div>
        <div class="drawer-side">
            <label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label>
            <ul class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">

                <li>
                    <a href="/" class="text-lg font-bold">
                        Smelter
                    </a>
                </li>

                <li><a href="/dashboard">Dashboard</a></li>
                <li><a href="/admins">Admins</a></li>
                <li><a href="/users">Users</a></li>
                <li>
                    <details open>
                        <summary>Cars</summary>
                        <ul>
                            <li><a href="/cars">Cars</a></li>
                            <li><a href="/car-body-types">Car body types</a></li>
                            <li><a href="/car-brands">Car brands</a></li>
                            <li><a href="/car-fuels">Car fuels</a></li>
                        </ul>
                    </details>
                </li>
                <li><a href="/transactions">Transactions</a></li>
            </ul>
        </div>
    </div>
@endsection
