<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\ApiUserAuthRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class UserAuthController extends Controller
{
    public function login(ApiUserAuthRequest $request)
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

    public function register(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email|unique:users,email',
                'name' => 'required',
                'password' => 'required|min:6',
            ]);

            $user = User::create([
                'email' => $request->email,
                'name' => $request->name,
                'password' => Hash::make($request->password)
            ]);

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

    // logout

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
