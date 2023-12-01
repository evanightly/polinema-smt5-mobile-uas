<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SearchCarRequest extends FormRequest
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
            'min_price' => ['nullable', 'numeric'],
            'max_price' => ['nullable', 'numeric'],
            'min_km' => ['nullable', 'numeric'],
            'max_km' => ['nullable', 'numeric'],
            'min_year' => ['nullable', 'numeric'],
            'max_year' => ['nullable', 'numeric'],
            'brand_id' => ['nullable', 'exists:car_brands,id'],
            'body_type_id' => ['nullable', 'exists:car_body_types,id'],
            'transmission' => ['nullable', 'in:Automatic,Manual'],
            'condition' => ['nullable', 'in:Used,New'],
        ];
    }
}
