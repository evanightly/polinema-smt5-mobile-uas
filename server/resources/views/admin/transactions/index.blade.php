@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5 my-8">
        <h1 class="text-2xl font-bold">Admins</h1>
        <a href="{{ url('admins/create') }}" class="btn btn-md btn-primary">Add Admin</a>
    </div>
    <table class="table table-zebra">
        <thead>
            <tr>
                <th>Name</th>
                <th>Payment Method</th>
                <th>Total</th>
                <th>Payment Proof</th>
                <th>Payment Date</th>
                <th>Status</th>
                <th>Verified By</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            @foreach ($transactions as $transaction)
                <tr>
                    <td class="flex gap-5 items-center">
                        {{ $transaction->user->name }}
                    </td>
                    <td>{{ $transaction->payment_method }}</td>
                    <td>
                        {{ $transaction->total }}
                    </td>
                    <td>
                        <img src="{{ asset('storage/' . $transaction->payment_proof) }}" alt="" class="w-32">
                    </td>
                    <td>{{ $transaction->payment_date }}</td>
                    <td>{{ $transaction->status }}</td>
                    <td>{{ $transaction->verified_by->name }}</td>
                    <td>
                        <button class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error"><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
