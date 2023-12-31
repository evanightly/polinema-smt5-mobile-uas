<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreCarRequest extends FormRequest
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
            'name' => ['required', 'string', 'max:255'],
            'brand_id' => ['required', 'string'],
            'body_type_id' => ['required', 'string'],
            'fuel_id' => ['required', 'string'],
            'year' => ['required', 'numeric', 'min:1900'],
            'mileage' => ['required', 'numeric', 'min:0'],
            'price' => ['required', 'numeric', 'min:1'],
            'image' => ['required', 'image', 'mimes:jpg,jpeg,png', 'max:2048'],
            'condition' => ['required', 'string', 'max:255', 'min:3'], // 'new', 'used
            'transmission' => ['required', 'string', 'max:255'], // 'manual', 'automatic
            'description' => ['string'],
            'stock' => ['required', 'numeric', 'min:0'],
        ];
    }
}
