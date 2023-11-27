@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Cars</h1>
        <a href="{{ url('cars/create') }}" class="btn btn-md btn-primary">Add Car</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Image</th>
                <th>Name</th>
                <th>Brand</th>
                <th>Body Type</th>
                <th>Year</th>
                <th>Speed</th>
                <th>Fuel</th>
                <th>Price</th>
                <th>Condition</th>
                <th>Transmission</th>
                <th>Status</th>
                <th>Stock</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($cars as $car)
                <tr>
                    <td>
                        <div class="flex gap-5 items-center">
                            <div class="avatar">
                                <div class="w-32 h-20">
                                    <img src="{{ $car->image_url }}" alt="{{ $car->name }}'Photo">
                                </div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <p>{{ $car->name }}</p>
                    </td>
                    <td>{{ $car->brand->name }}</td>
                    <td>{{ $car->bodyType->name }}</td>
                    <td>{{ $car->year }}</td>
                    <td>0 - {{ $car->km_max }} Km</td>
                    <td>{{ $car->fuel->name }}</td>
                    <td>{{ $car->price }}</td>
                    <td>{{ $car->condition }}</td>
                    <td>{{ $car->transmission }}</td>
                    <td>{{ $car->status }}</td>
                    <td>{{ $car->stock }}</td>
                    <td>
                        <div class="flex gap-3">
                            <a href="{{ route('cars.show', [$car]) }}" class="btn btn-accent">
                                <i class="fa-solid fa-eye"></i>
                            </a>

                            <a href="{{ route('cars.edit', [$car]) }}" class="btn btn-primary">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>

                            <dialog id="confirmDeleteModal{{ $loop->index }}" class="modal">
                                <div class="modal-box">
                                    <h3 class="font-bold text-lg">Are you sure?</h3>
                                    <div class="py-4">
                                        <p>You are about to delete {{ $car->name }}</p>
                                        <p class="text-bold">
                                            <span class="text-warning">Warning</span>
                                            <span>: this operation will delete all data related to this Car, <span class="font-bold text-error">including transactions!</span></span>
                                        </p>
                                    </div>

                                    <div class="modal-action">
                                        <form method="dialog" action="">
                                            <button class="btn">Cancel</button>
                                        </form>

                                        <form action="{{ route('cars.destroy', [$car->id]) }}" method="post">
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

                            <button class="btn btn-error" onclick="confirmDeleteModal{{ $loop->index }}.showModal()">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
