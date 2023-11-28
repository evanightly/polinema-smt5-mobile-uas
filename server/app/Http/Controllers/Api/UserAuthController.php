<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\ApiUserAuthLoginRequest;
use App\Http\Requests\ApiUserAuthRegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserAuthController extends Controller
{
    public function login(ApiUserAuthLoginRequest $request)
    {
        if ($request->validated()) {
            $user = User::where('email', $request->email)->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'message' => 'Login failed',
                    'error' => 'The provided credentials are incorrect.'
                ], 401);
            }

            $token = $user->createToken('user-token')->plainTextToken;

            return response()->json([
                'message' => 'Login success',
                'user' => new UserResource($user),
                'token' => $token
            ]);
        }
    }

    public function register(ApiUserAuthRegisterRequest $request)
    {
        try {
            $user = User::create($request->validated());

            return response()->json([
                'message' => 'Register success',
                'data' => [
                    'user' => $user,
                    'token' => $user->createToken($user->id)->plainTextToken
                ],
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Register failed',
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
