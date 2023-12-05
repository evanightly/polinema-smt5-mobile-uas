<?php

namespace App\Http\Controllers;

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
        return view('users.index', [
            'users' => UserResource::collection(User::latest()->get())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('users.create');
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

            $newUser = new UserResource(User::create($validated->all()));
            return redirect()->route('users.index')->with('success', "$newUser->name has been created");
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(User $user)
    {
        return view('users.edit', [
            'user' => new UserResource($user)
        ]);
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

            $newUser = new UserResource(tap($user)->update($validated->all()));
            return redirect()->route('users.index')->with('success', "$newUser->name has been updated");
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        File::delete(public_path('storage/images/users/' . $user->image));
        $user->delete();
        return redirect()->route('users.index')->with('success', "$user->name has been removed");
    }
}
