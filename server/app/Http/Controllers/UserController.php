<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Models\User;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view('admin.users.index', [
            'users' => User::all()
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUserRequest $request)
    {
        if (!$request->hasFile('image')) {
            return response()->json([
                'message' => 'Image not found'
            ], 400);
        }
        $image = $request->file('image')->store('images/users', 'public');
        $image_name = explode('/', $image)[2];

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'image' => $image_name,
            'address' => $request->address
        ]);

        return $user;
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        return $user->load(
            ['transactions' => [
                'verifiedBy',
                'detailTransactions' => [
                    'car' => [
                        'bodyType',
                        'brand',
                        'fuel'
                    ]
                ]
            ]]
        );
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(User $user)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request, User $user)
    {
        try {
            // check if the request has file
            if ($request->hasFile('image')) {
                // if the image starts with http then don't do anything
                if (strpos($request->image, 'http') !== false) {
                    $image_name = $user->image;
                }

                if ($user->image) {
                    if (file_exists(public_path('storage/images/users/' . $user->image))) {
                        // delete the image
                        unlink(public_path('storage/images/users/' . $user->image));
                    }
                }
                // store the new image
                $image = $request->file('image')->store('images/users', 'public');
                $image_name = explode('/', $image)[2];
            } else {
                $image_name = $user->image;
            }
            $user->update([
                'name' => $request->name,
                'email' => $request->email,
                'password' => $request->password,
                'image' => $image_name,
                'address' => $request->address
            ]);
            return response()->json([
                'message' => 'User updated successfully'
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Something went wrong',
                'error' => $th->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        try {
            // delete user with its image
            if ($user->image) {
                if (file_exists(public_path('storage/images/users/' . $user->image))) {
                    // delete the image
                    unlink(public_path('storage/images/users/' . $user->image));
                }
            }
            $user->delete();
            return response()->json([
                'message' => 'User deleted successfully'
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Something went wrong',
                'error' => $th->getMessage()
            ], 400);
        }
    }
}
