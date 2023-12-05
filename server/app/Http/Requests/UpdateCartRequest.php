<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCartRequest extends FormRequest
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
            'quantity' => ['required'],
            'subtotal' => ['nullable'],
        ];
    }

    protected function prepareForValidation(): void
    {
        $car_price = $this->route('cart')->car->price;

        $this->merge([
            'subtotal' => $this->quantity * $car_price
        ]);
    }

}
