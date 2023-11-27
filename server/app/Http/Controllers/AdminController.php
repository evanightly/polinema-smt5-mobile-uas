<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Http\Requests\StoreAdminRequest;
use App\Http\Requests\UpdateAdminRequest;
use App\Http\Resources\AdminResource;
use Illuminate\Support\Facades\File;

class AdminController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view('admins.index', [
            'admins' => AdminResource::collection(Admin::latest()->get())
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admins.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreAdminRequest $request)
    {
        if ($request->validated()) {
            $path = $request->file('image')->store('images/admins', 'public');
            $file_name = explode('/', $path)[2];
            $validated = $request->safe()->merge(['image' => $file_name]);

            $newAdmin = new AdminResource(Admin::create($validated->all()));
            return redirect()->route('admins.index')->with('success', "$newAdmin->name has been created");
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Admin $admin)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Admin $admin)
    {
        return view('admins.edit', [
            'admin' => new AdminResource($admin)
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateAdminRequest $request, Admin $admin)
    {
        if ($request->validated()) {

            $validated = $request->safe();
            // if file exists, delete it
            if ($request->hasFile('image')) {
                File::delete(public_path('storage/images/admins/' . $admin->image));

                $path = $request->file('image')->store('images/admins', 'public');
                $file_name = explode('/', $path)[2];
                $validated = $request->safe()->merge(['image' => $file_name]);
            }

            $newAdmin = new AdminResource(tap($admin)->update($validated->all()));
            return redirect()->route('admins.index')->with('success', "$newAdmin->name has been updated");
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Admin $admin)
    {
        File::delete(public_path('storage/images/admins/' . $admin->image));
        $admin->delete();
        return redirect()->route('admins.index')->with('success', "$admin->name has been eliminated");
    }
}
