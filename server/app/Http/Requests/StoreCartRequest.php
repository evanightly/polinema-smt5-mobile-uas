<?php

namespace App\Http\Requests;

use App\Models\Car;
use Illuminate\Foundation\Http\FormRequest;

class StoreCartRequest extends FormRequest
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
            'user_id' => ['required', 'exists:users,id'],
            'car_id' => ['required', 'exists:cars,id'],
            'quantity' => ['required', 'numeric'],
            'subtotal' => ['nullable'],
        ];
    }

    protected function prepareForValidation(): void
    {
        $car_price = Car::find($this->car_id)->price;

        $this->merge([
            'subtotal' => $this->quantity * $car_price
        ]);
    }
}
