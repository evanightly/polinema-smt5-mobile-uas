@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Transactions</h1>
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
                    <td>
                        {{ $transaction->user->name }}
                    </td>
                    <td>{{ $transaction->payment_method }}</td>
                    <td>
                        {{ $transaction->total }}
                    </td>
                    <td>
                        <img src="{{ $transaction->payment_proof_url }}" alt="" class="w-32">
                    </td>
                    <td>{{ $transaction->payment_date }}</td>
                    <td>{{ $transaction->status }}</td>
                    <td>{{ $transaction->verifiedBy->name ?? '' }}</td>
                    <td>
                        <button class="btn btn-primary" disabled><i class="fa-solid fa-pen-to-square"></i></button>
                        <button class="btn btn-error" disabled><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
