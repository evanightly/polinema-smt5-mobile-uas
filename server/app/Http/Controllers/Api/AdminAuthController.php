<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\ApiAdminAuthRequest;
use App\Http\Resources\AdminResource;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AdminAuthController extends Controller
{
    public function login(ApiAdminAuthRequest $request)
    {
        if ($request->validated()) {
            $admin = Admin::where('email', $request->email)->first();

            if (!$admin || !Hash::check($request->password, $admin->password)) {
                return response()->json([
                    'message' => 'Login failed',
                    'error' => 'The provided credentials are incorrect.'
                ], 401);
            }

            $token = $admin->createToken('admin-token')->plainTextToken;

            return response()->json([
                'message' => 'Login success',
                'admin' => new AdminResource($admin),
                'token' => $token
            ]);
        }
    }

    public function show(Admin $admin)
    {
        try {
            return response()->json([
                'message' => 'Get admin success',
                'data' => new AdminResource($admin)
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Get admin failed',
                'error' => $th->getMessage()
            ], 401);
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
