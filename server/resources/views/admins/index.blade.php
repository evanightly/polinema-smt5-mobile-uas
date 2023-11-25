@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Admins</h1>
        <a href="{{ route('admins.create') }}" class="btn btn-md btn-primary">Add Admin</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Joined At</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($admins as $admin)
                <tr>
                    <td>
                        <div class="flex items-center gap-5">
                            <div class="avatar">
                                <div class="w-12 rounded-full">
                                    <img src="{{ $admin->imageUrl }}" alt="{{ $admin->name }}'Photo">
                                </div>
                            </div>
                            <p>{{ $admin->name }}</p>
                        </div>
                    </td>
                    <td>{{ $admin->email }}</td>
                    <td>
                        @if ($admin->isSuperAdmin)
                            <span class="badge badge-primary">Super Admin</span>
                        @else
                            <span class="badge badge-secondary">Admin</span>
                        @endif
                    </td>
                    <td>{{ $admin->joinedAt }}</td>
                    <td class="flex gap-3">
                        <div class="flex gap-3">

                            <dialog id="confirmDeleteModal{{ $loop->index }}" class="modal">
                                <div class="modal-box">
                                    <h3 class="font-bold text-lg">Are you sure?</h3>
                                    <div class="py-4">
                                        <p>You are about to delete {{ $admin->name }}</p>
                                        <p class="text-bold">
                                            <span class="text-warning">Warning</span>
                                            <span>: this operation will delete all data related to this Admin</span>
                                        </p>
                                    </div>

                                    <div class="modal-action">
                                        <form method="dialog" action="">
                                            <button class="btn">Cancel</button>
                                        </form>

                                        <form action="{{ route('admins.destroy', [$admin->id]) }}" method="post">
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

                            <a href="{{ route('admins.edit', [$admin]) }}" class="btn btn-primary">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>

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
