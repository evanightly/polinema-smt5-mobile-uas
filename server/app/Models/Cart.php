<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    // https://discuss.educative.io/t/relationship-between-cart-user/33795

    use HasFactory;

    protected $fillable = [
        'user_id',
        'car_id',
        'quantity',
        'subtotal',
    ];

    // Cart model has a one-to-many relationship with the User model.
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Cart model has a one-to-many relationship with the Car model.
    public function car()
    {
        return $this->belongsTo(Car::class);
    }

    public function getFormattedSubtotalAttribute($value)
    {
        return number_format($this->subtotal, 0, ',', '.');
    }
}
