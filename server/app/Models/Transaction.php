<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'payment_method', // ['Cash', 'Credit Card', 'Debit Card']
        'payment_proof',
        'payment_date',
        'total',
        'status', // ['Pending', 'On Going', 'Finished', 'Rejected', 'Verified']
        'verified_by', // Admin
        'verified_at',
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
