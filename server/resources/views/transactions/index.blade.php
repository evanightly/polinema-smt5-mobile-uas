@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="flex items-center gap-5">
        <h1 class="text-2xl font-bold">Transactions</h1>
    </div>
    <table id="main-table" class="table table-zebra">
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
                    {{-- Status text with criteria: orange color if pending red color if rejected, blue color if verified, green color if finished --}}
                    <td>
                        @if ($transaction->status === 'Pending')
                            <span class="badge badge-warning">{{ $transaction->status }}</span>
                        @elseif($transaction->status === 'Rejected')
                            <span class="badge badge-error">{{ $transaction->status }}</span>
                        @elseif($transaction->status === 'Verified')
                            <span class="badge badge-primary">{{ $transaction->status }}</span>
                        @elseif($transaction->status === 'Finished')
                            <span class="badge badge-success">{{ $transaction->status }}</span>
                        @endif
                    </td>
                    <td>{{ $transaction->verifiedBy->name ?? '' }}</td>
                    <td>
                        <a href="{{ route('transactions.edit', [$transaction]) }}" class="btn btn-primary"><i
                                class="fa-solid fa-pen-to-square"></i></a>
                        <button class="btn btn-error" disabled><i class="fa-solid fa-trash-can"></i></button>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection

@push('postscripts')
    <script>
        new DataTable('#main-table', {
            info: false,
            searching: false,
            serverSide: false,
            paging: false,
        })
    </script>
@endpush
