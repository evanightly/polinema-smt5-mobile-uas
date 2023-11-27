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
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:admins'],
            'password' => ['required', 'string'],
            'image' => ['required', 'image', 'mimes:jpg,jpeg,png', 'max:2048'],
            'is_super_admin' => ['nullable'],  // checkbox value is either null or 'on'
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'is_super_admin' => $this->has('is_super_admin') && $this->is_super_admin === 'on' ? true : false,
            'password' => Hash::make($this->password)
        ]);
    }
}
