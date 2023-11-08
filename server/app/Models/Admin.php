<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    use HasFactory;
    use HasUuids;

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
