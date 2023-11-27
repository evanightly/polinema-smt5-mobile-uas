@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Users</h1>
        <a href="{{ route('users.create') }}" class="btn btn-md btn-primary">Add User</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Joined At</th>
                <th>Address</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($users as $user)
                <tr>
                    <td>
                        <div class="flex items-center gap-5">
                            <div class="avatar">
                                <div class="w-12 rounded-full">
                                    <img src="{{ $user->image_url }}" alt="{{ $user->name }}'Photo">
                                </div>
                            </div>
                            <p>{{ $user->name }}</p>
                        </div>
                    </td>
                    <td>{{ $user->email }}</td>
                    <td>{{ $user->joinedAt }}</td>
                    <td>{{ $user->address }}</td>
                    <td>
                        <div class="flex gap-3">
                            <dialog id="confirmDeleteModal{{ $loop->index }}" class="modal">
                                <div class="modal-box">
                                    <h3 class="font-bold text-lg">Are you sure?</h3>
                                    <div class="py-4">
                                        <p>You are about to delete {{ $user->name }}</p>
                                        <p class="text-bold">
                                            <span class="text-warning">Warning</span>
                                            <span>: this operation will delete all data related to this user</span>
                                        </p>
                                    </div>

                                    <div class="modal-action">
                                        <form method="dialog" action="">
                                            <button class="btn">Cancel</button>
                                        </form>

                                        <form action="{{ route('users.destroy', [$user->id]) }}" method="post">
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

                            <a href="{{ route('users.edit', [$user]) }}" class="btn btn-primary">
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
