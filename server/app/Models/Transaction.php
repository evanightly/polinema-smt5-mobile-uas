<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'car_id',
        'payment_method', // ['Cash', 'Credit Card', 'Debit Card']
        'payment_proof',
        'payment_date',
        'payment_amount',
        'payment_status', // ['Pending', 'Success', 'Failed']
    ];
    
    // User has many transaction of car
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    
    public function car()
    {
        return $this->belongsTo(Car::class);
    }
}
