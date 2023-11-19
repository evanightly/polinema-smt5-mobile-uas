<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class UserAuthController extends Controller
{
    public function login(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'password' => 'required',
            ]);

            $user = User::where('email', $request->email)->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                return ValidationException::withMessages([
                    'email' => ['The provided credentials are incorrect.'],
                ]);
            }

            return response()->json([
                'message' => 'Login success',
                'data' => [
                    'user' => $user,
                    'token' => $user->createToken($user->id)->plainTextToken
                ],
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Login failed',
                'error' => $th->getMessage()
            ], 401);
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
