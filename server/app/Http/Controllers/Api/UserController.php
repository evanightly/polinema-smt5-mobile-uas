<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Support\Facades\File;

class UserController extends Controller
{

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return UserResource::collection(User::latest()->get());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUserRequest $request)
    {
        if ($request->validated()) {
            $path = $request->file('image')->store('images/users', 'public');
            $file_name = explode('/', $path)[2];
            $validated = $request->safe()->merge(['image' => $file_name]);

            return new UserResource(User::create($validated->all()));
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        return new UserResource($user->load([
            'transaction' => [
                'detailTransaction' => [
                    'car' => ['brand', 'bodyType', 'fuel']
                ],
            ],

            'cart' => [
                'car' => ['brand', 'bodyType', 'fuel']
            ]
        ]));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request, User $user)
    {
        if ($request->validated()) {

            $validated = $request->safe();
            // if file exists, delete it
            if ($request->hasFile('image')) {
                File::delete(public_path('storage/images/users/' . $user->image));

                $path = $request->file('image')->store('images/users', 'public');
                $file_name = explode('/', $path)[2];
                $validated = $request->safe()->merge(['image' => $file_name]);
            }

            return new UserResource(tap($user)->update($validated->all()));
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        File::delete(public_path('storage/images/users/' . $user->image));
        $user->delete();
        return response()->noContent();
    }

    /**
     * Display transactions of the specified user.
     */
    public function transactions(User $user)
    {
        return new UserResource($user->load(['transactions' => ['detailTransactions' => ['car' => ['brand', 'bodyType', 'fuel']]]]));
    }

    /**
     * Display carts of the specified user.
     */
    public function carts(User $user)
    {
        return new UserResource($user->load(['carts' => ['car' => ['brand', 'bodyType', 'fuel']]]));
    }
}
