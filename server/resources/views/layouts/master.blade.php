@include('sweetalert::alert')

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite('resources/css/app.css')
    <link rel="stylesheet" href="{{ asset('css/all.min.css') }}" type="text/css">
    <link rel="stylesheet" href="{{ asset('css/sweetalert2.min.css') }}" type="text/css">
    <script src="{{ asset('js/sweetalert2.all.min.js') }}"></script>

    <title>Ambatucar</title>
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
                    <li class="rounded-lg  bg-red-500 py-3 px-2">{{ $error }}</li>
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


</body>

</html>
