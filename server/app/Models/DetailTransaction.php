<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetailTransaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'transaction_id',
        'car_id',
        'car_price', // price when transaction happened
        'qty',
        'subtotal',
    ];

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function car()
    {
        return $this->belongsTo(Car::class);
    }
}
