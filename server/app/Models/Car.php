<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\CarBrand;
use App\Models\CarBodyType;
use App\Models\CarFuel;

class Car extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'brand_id', // ['Toyota', 'Honda', 'Suzuki', 'Mitsubishi', 'Daihatsu', 'Mazda', 'Nissan', 'Mercedes-Benz', 'BMW', 'Audi', 'Lexus', 'Isuzu']
        'body_type_id', // ['SUV', 'Sedan', 'Hatchback', 'MPV', 'Wagon']
        'year',
        'mileage', // Jarak tempuh
        'fuel_id', // ['Pertamax', 'Solar']
        'price',
        'image',
        'description',
        'condition', // ['Used', 'New']
        'transmission', // ['Automatic', 'Manual']
        'stock'
    ];

    public function brand()
    {
        return $this->hasOne(CarBrand::class, 'id', 'brand_id');
    }

    public function bodyType()
    {
        return $this->hasOne(CarBodyType::class, 'id', 'body_type_id');
    }

    public function fuel()
    {
        return $this->hasOne(CarFuel::class, 'id', 'fuel_id');
    }

    public function getImageUrlAttribute()
    {
        // check if image starts with http
        if (strpos($this->image, 'http') === 0) {
            return $this->image;
        }
        return asset('storage/images/cars/' . $this->image);
    }
}
