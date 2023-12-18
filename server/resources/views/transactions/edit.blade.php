@extends('layouts.admin_dashboard')

@section('content-dashboard')
    <div class="p-5 rounded-lg bg-base-200">
        <div class="flex flex-col gap-1">
            <p class="text-lg">Buyer: {{ $transaction->user->name }}</p>
            <p class="text-lg">Verified By: {{ $transaction->verifiedBy->name ?? '' }}</p>
            <p class="text-lg">Verified At: {{ $transaction->formatted_verified_at }}</p>
            <div class="flex items-center gap-2">
                <p class="text-lg">Transaction Status: </p>

                @if ($transaction->status === 'Pending')
                    <span class="badge badge-warning">{{ $transaction->status }}</span>
                @elseif($transaction->status === 'Rejected')
                    <span class="badge badge-error">{{ $transaction->status }}</span>
                @elseif($transaction->status === 'Verified')
                    <span class="badge badge-primary">{{ $transaction->status }}</span>
                @elseif($transaction->status === 'Finished')
                    <span class="badge badge-success">{{ $transaction->status }}</span>
                @endif
            </div>
        </div>

        <table class="table my-5 rounded-lg bg-base-100">
            <thead>
                <tr>
                    <th>Car</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($transaction->detailTransactions as $dt)
                    <tr>
                        <td>
                            <div class="flex items-center gap-3">
                                <img src="{{ $dt->car->imageUrl }}" alt="{{ $dt->car->name }} thumbnail" class="h-16">
                                <p>{{ $dt->car->name }}</p>
                            </div>
                        </td>
                        <td>{{ $dt->car->price }}</td>
                        <td>{{ $dt->qty }}
                            <span class="{{ $dt->qty > $dt->car->stock ? 'text-error' : 'text-success' }}">
                                ({{ $dt->car->stock }} Available)
                            </span>
                        </td>
                        <td>{{ $dt->subtotal }}</td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="4" class="text-center">No Cars</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        <div class="flex">
            <div class="flex-1">
                <p class="text-lg">Total: ${{ $transaction->formatted_total }}</p>
                <p class="text-lg">Payment Method: {{ $transaction->payment_method }}</p>
                <p class="text-lg">Payment Date: {{ $transaction->formatted_payment_date }}</p>
            </div>
            <div class="flex-1">
                <p class="text-lg">Payment Proof:</p>
                <img src="{{ $transaction->payment_proof_url }}" alt="" class="h-44">
            </div>
        </div>
        @if ($transaction->status !== 'Finished' && $transaction->status !== 'Rejected')
            <div class="flex flex-col justify-start gap-3">
                <p class="text-lg">Change Transaction Status</p>
                <form action="{{ route('transactions.update', [$transaction]) }}" method="POST">
                    @csrf
                    @method('PUT')
                    {{-- Input: verified_by verified_at --}}
                    <input type="hidden" name="verified_by" value="{{ Auth::user()->id }}">
                    <input type="hidden" name="verified_at" value="{{ now() }}">
                    @if ($transaction->status === 'Verified')
                        <input type="hidden" name="status" value="Finished">
                        <button type="submit" class="btn btn-success">Mark As Finish</button>
                    @else
                        <button type="submit" class="btn btn-success" name="status" value="Verified">Accept</button>
                        <button type="submit" class="btn btn-error" name="status" value="Rejected">Reject</button>
                    @endif
                </form>
            </div>
        @endif
    </div>
@endsection
