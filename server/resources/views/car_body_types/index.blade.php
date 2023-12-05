@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Car Body Type</h1>
        <a href="{{ url('car-body-types/create') }}" class="btn btn-md btn-primary">Add Body Type</a>
    </div>
    <table id="main-table" class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($carBodyTypes as $carBodyType)
                <tr>
                    <td>{{ $carBodyType->name }}</td>
                    <td>
                        <div class="flex gap-3">

                            <a href="{{ route('car-body-types.edit', [$carBodyType]) }}" class="btn btn-primary">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>

                            @if ($carBodyType->cars->count() <= 0)
                                <button class="btn btn-error" onclick="confirmDeleteModal{{ $loop->index }}.showModal()">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>

                                <dialog id="confirmDeleteModal{{ $loop->index }}" class="modal">
                                    <div class="modal-box">
                                        <h3 class="text-lg font-bold">Are you sure?</h3>
                                        <div class="py-4">
                                            <p>You are about to delete {{ $carBodyType->name }}</p>
                                        </div>

                                        <div class="modal-action">
                                            <form method="dialog" action="">
                                                <button class="btn">Cancel</button>
                                            </form>

                                            <form action="{{ route('car-body-types.destroy', [$carBodyType->id]) }}"
                                                method="post">
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

@push('postscripts')
    <script>
        new DataTable('#main-table')
    </script>
@endpush
