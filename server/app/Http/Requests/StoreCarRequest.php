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
            'name' => ['required', 'string', 'max:255', 'min:3'],
            'brand' => ['required', 'string', 'max:255', 'min:3'],
            'price' => ['required', 'numeric', 'min:1'],
            'image' => ['image', 'mimes:jpg,jpeg,png', 'max:2048'],
            'description' => ['required', 'string', 'min:10'],
            'isAvailable' => ['required', 'boolean'],
        ];
    }
}
