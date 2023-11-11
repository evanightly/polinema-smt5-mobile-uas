<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Model
{
    use HasApiTokens, HasFactory , Notifiable, HasUuids;

    protected $fillable = [
        'name',
        'email',
        'password',
        'image',
        'isSuperAdmin'
    ];

    protected $hidden = [
        'password',
    ];

    protected $keyType = 'string';
    public $incrementing = false;
}
