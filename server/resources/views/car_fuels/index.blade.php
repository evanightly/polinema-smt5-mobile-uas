@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Car Fuel</h1>
        <a href="{{ url('car-fuels/create') }}" class="btn btn-md btn-primary">Add Fuel</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($carFuels as $carFuel)
                <tr>
                    <td>{{ $carFuel->name }}</td>
                    <td>
                        <div class="flex gap-3">

                            <a href="{{ route('car-fuels.edit', [$carFuel]) }}" class="btn btn-primary">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>

                            @if ($carFuel->cars->count() <= 0)
                                <button class="btn btn-error" onclick="confirmDeleteModal{{ $loop->index }}.showModal()">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>

                                <dialog id="confirmDeleteModal{{ $loop->index }}" class="modal">
                                    <div class="modal-box">
                                        <h3 class="font-bold text-lg">Are you sure?</h3>
                                        <div class="py-4">
                                            <p>You are about to delete {{ $carFuel->name }}</p>
                                        </div>

                                        <div class="modal-action">
                                            <form method="dialog" action="">
                                                <button class="btn">Cancel</button>
                                            </form>

                                            <form action="{{ route('car-fuels.destroy', [$carFuel->id]) }}" method="post">
                                                @csrf
                                                @method('DELETE')
                                                <button class="btn btn-error">Yes, I Agree</button>
                                            </form>
                                        </div>
                                    </div>

                                    <form method="dialog" class="modal-backdrop">
                                        <button>close</button>
                                    </form>
                                </dialog>
                            @endif
                        </div>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
