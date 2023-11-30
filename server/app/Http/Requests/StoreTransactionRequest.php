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
            'user_id' => 'required|exists:users,id',
            'payment_method' => 'required|in:Cash,CreditCard,DebitCard',
            'payment_proof' => 'image|max:2048',
            /**
             * Total is not required because it will be calculated from the cart
             * 'total' => 'required|numeric|min:0',
             */
            'delivery_address' => 'required|string|max:255',
        ];
    }
}
