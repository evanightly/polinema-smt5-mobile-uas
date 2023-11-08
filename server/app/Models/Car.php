<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Car extends Model
{
    use HasFactory;

    // implement carmudi car data model
    protected $fillable = [
        'name',
        'brand', // ['Toyota', 'Honda', 'Suzuki', 'Mitsubishi', 'Daihatsu', 'Mazda', 'Nissan', 'Mercedes-Benz', 'BMW', 'Audi', 'Lexus', 'Isuzu']
        'body_type', // ['SUV', 'Sedan', 'Hatchback', 'MPV', 'Wagon']
        'year',
        'km_min', // 'km_min' and 'km_max' are used to determine the range of km
        'km_max',
        'fuel', // ['Pertamax', 'Solar']
        'price',
        'image',
        'description',
        'condition', // ['Used', 'New']
        'transmission', // ['Automatic', 'Manual']
        'status' // ['Available', 'Sold']
    ];
}
