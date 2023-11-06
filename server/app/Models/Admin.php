<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    use HasFactory;
    use HasUuids;

    protected $name;
    protected $email;
    protected $password;
    protected $isSuperAdmin;
    protected $image;

    protected $keyType = 'string';
    public $incrementing = false;
}
