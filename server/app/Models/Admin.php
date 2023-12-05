<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasUuids;

    protected $fillable = [
        'name',
        'email',
        'password',
        'image',
        'is_super_admin',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $keyType = 'string';
    public $incrementing = false;

    public function getJoinedAtAttribute()
    {
        return $this->created_at->format('d M Y');
    }

    public function getImageUrlAttribute()
    {
        // check if image starts with http
        if (strpos($this->image, 'http') === 0) {
            return $this->image;
        }
        return asset('storage/images/admins/' . $this->image);
    }
}
