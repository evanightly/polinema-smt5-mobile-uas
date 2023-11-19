<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTransactionRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {

        return [
            'user_id' => ['exists:users,id'],
            'payment_method' => ['in:Cash,CreditCard,DebitCard'],
            'payment_proof' => ['image', 'max:2048'],
            'payment_date' => ['date'],
            'total' => ['numeric'],
            'status' => ['in:On Going,Pending,Rejected,Verified,Finished'],
            'verified_by' => ['exists:admins,id'],
            'verified_at' => ['date'],
            'deliver_address' => ['string'],
        ];
    }
}
