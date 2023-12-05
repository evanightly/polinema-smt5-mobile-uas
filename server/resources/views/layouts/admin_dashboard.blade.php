@extends('layouts.master')

@section('content')
    <div class="drawer lg:drawer-open">
        <input id="dashboard-sidebar" type="checkbox" class="drawer-toggle" />
        <div class="drawer-content flex flex-col items-center gap-5">

            <!-- Page content here -->

            @once
                @include('components.admin_dashboard_navbar')
            @endonce

            <div class="container px-8 flex flex-col gap-5">
                @yield('content-dashboard')
            </div>
        </div>
        <div class="drawer-side">
            <label for="dashboard-sidebar" aria-label="close sidebar" class="drawer-overlay"></label>
            <ul id="dashboard-sidebar" class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
                <li>
                    <span class="text-lg font-bold">
                        Ambatucar
                    </span>
                </li>
                <li><a href="/"><i class="fa-solid fa-house"></i>Dashboard</a></li>
                <li><a href="/admins"><i class="fa-solid fa-users-gear"></i>Admins</a></li>
                <li><a href="/users"><i class="fa-solid fa-user-group"></i>Users</a></li>
                <li>
                    <details open>
                        <summary><i class="fa-solid fa-car"></i>Cars</summary>
                        <ul>
                            <li><a href="/cars"><i class="fa-solid fa-car-rear"></i>Cars</a></li>
                            <li><a href="/car-body-types"><i class="fa-solid fa-car-side"></i>Car body types</a></li>
                            <li><a href="/car-brands"><i class="fa-solid fa-copyright"></i>Car brands</a></li>
                            <li><a href="/car-fuels"><i class="fa-solid fa-gas-pump"></i>Car fuels</a></li>
                        </ul>
                    </details>
                </li>
                <li><a href="/transactions"><i class="fa-solid fa-handshake"></i>Transactions</a></li>
            </ul>
        </div>
    </div>
@endsection

@section('postscripts')
    <script>
        const currentUrl = window.location.pathname;

        $('#dashboard-sidebar.menu li').each(function() {
            // if current page is the same as the link, but not the '/' link
            console.log($(this).children('a').attr('href'))
            if (currentUrl === $(this).children('a').attr('href')) {
                $(this).addClass('active');
            }
        });


        /**
         * darkTheme and lightTheme variable is defined in views/layouts/master.blade.php
         **/

        let themeToggleBtn = document.getElementById('theme-toggle');

        // set themeToggleBtm to checked if theme is dark
        if (localStorage.getItem('theme') === 'dark') {
            themeToggleBtn.checked = true;
        }

        themeToggleBtn.addEventListener('click', function() {
            // if set via local storage previously
            if (localStorage.getItem('theme')) {
                if (localStorage.getItem('theme') === 'light') {
                    $('html').attr('data-theme', darkTheme)
                    localStorage.setItem('theme', 'dark');
                } else {
                    $('html').attr('data-theme', lightTheme)
                    localStorage.setItem('theme', 'light');
                }

                // if NOT set via local storage previously
            } else {
                if (document.documentElement.classList.contains('dark')) {
                    $('html').attr('data-theme', lightTheme)
                    localStorage.setItem('theme', 'light');
                } else {
                    $('html').attr('data-theme', darkTheme)
                    localStorage.setItem('theme', 'dark');
                }
            }
        });
    </script>
@endsection
