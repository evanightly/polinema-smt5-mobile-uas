<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite('resources/css/app.css')
    <link rel="icon" href="{{ asset('img/logo.jpeg') }}" type="image/jpeg">

    <link rel="stylesheet" href="{{ asset('css/all.min.css') }}" type="text/css">
    <link rel="stylesheet" href="{{ asset('css/sweetalert2.min.css') }}" type="text/css">
    <link rel="stylesheet" href="{{ asset('css/datatables.min.css') }}" type="text/css">
    <script src="{{ asset('js/sweetalert2.all.min.js') }}"></script>
    <script src="{{ asset('js/jquery-3.7.1.min.js') }}"></script>
    <script src="{{ asset('js/datatables.min.js') }}"></script>

    <script>
        const darkTheme = 'customDarkTheme'
        const lightTheme = 'customLightTheme'

        let theme = localStorage.theme || 'light'
        if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia(
                '(prefers-color-scheme: dark)').matches)) {
            theme = darkTheme
        } else {
            theme = lightTheme
        }

        $('html').attr('data-theme', theme)
    </script>

    @yield('prescripts')


    <title>WheelWizards</title>
</head>

<body>
    @yield('content')

    @error('password')
        <div class="alert alert-danger">{{ $message }}</div>
    @enderror

    <script>
        const Toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.onmouseenter = Swal.stopTimer;
                toast.onmouseleave = Swal.resumeTimer;
            }
        });

        @if ($errors->any())
            Toast.fire({
                icon: 'error',
                title: 'Validation error',
                html: `<ul class="flex flex-col gap-5 text-white">
                @foreach ($errors->all() as $error)
                    <li class="px-2 py-3 bg-red-500 rounded-lg">{{ $error }}</li>
                @endforeach
            </ul>`
            });
        @endif

        @if (session('success'))
            Toast.fire({
                icon: 'success',
                title: '{{ session('success') }}'
            });
        @endif
    </script>


    @stack('postscripts')

</body>

</html>
