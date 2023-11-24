<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Hash;

class StoreAdminRequest extends FormRequest
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
            'email' => ['required', 'email', 'unique:admins'],
            'password' => ['required', 'string', 'min:8'],
            'image' => ['required', 'image', 'mimes:jpg,jpeg,png', 'max:2048'],
            'isSuperAdmin' => ['nullable', 'boolean'],
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'isSuperAdmin' => $this->has('isSuperAdmin') && $this->isSuperAdmin === 'on' ? true : false,
        ]);
    }

    protected function passedValidation(): void
    {
        $this->replace(['password' => Hash::make($this->password)]);
    }
}
