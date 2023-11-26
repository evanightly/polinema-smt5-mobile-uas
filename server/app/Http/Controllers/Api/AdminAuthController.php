<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\ApiAuthAdminRequest;
use App\Http\Resources\AdminResource;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AdminAuthController extends Controller
{
    public function login(ApiAuthAdminRequest $request)
    {
        if ($request->validated()) {
            $admin = Admin::where('email', $request->email)->first();

            if (!$admin || !Hash::check($request->password, $admin->password)) {
                throw ValidationException::withMessages([
                    'email' => ['The provided credentials are incorrect.']
                ]);
            }

            $token = $admin->createToken('admin-token')->plainTextToken;

            dump(response()->json([
                'message' => 'Login success',
                'admin' => new AdminResource($admin),
                'token' => $token
            ]));
            return response()->json([
                'message' => 'Login success',
                'admin' => new AdminResource($admin),
                'token' => $token
            ]);
        }
    }

    public function logout(Request $request)
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return response()->json([
                'message' => 'Logout success'
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Logout failed',
                'error' => $th->getMessage()
            ], 401);
        }
    }
}
