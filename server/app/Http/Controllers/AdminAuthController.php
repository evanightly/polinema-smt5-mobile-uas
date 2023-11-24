<?php

namespace App\Http\Controllers;

use App\Http\Requests\AdminAuthRequest;
use Illuminate\Http\Request;

class AdminAuthController extends Controller
{
    public function index()
    {
        return view('auth.login');
    }

    public function login(AdminAuthRequest $request)
    {
        // try {
        //     $user = Admin::where('email', $request->email)->first();

        //     if (!$user || !Hash::check($request->password, $user->password)) {
        //         throw ValidationException::withMessages([
        //             'email' => ['The provided credentials are incorrect.'],
        //         ]);
        //     }

        //     Session()->put('admin', $user);

        //     return redirect()->route('admin/dashboard');
        // } catch (\Throwable $th) {
        //     return redirect()->route('admin/login')->with('error', $th->getMessage());
        // }

        return redirect()->route('admin/');
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
