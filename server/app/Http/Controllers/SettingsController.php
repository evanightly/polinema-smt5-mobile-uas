<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function profile()
    {
        return view('settings.profile', [
            'admin' => auth()->user()
        ]);
    }
}
