<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CarResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'car_brand_id' => $this->car_brand_id,
            'car_body_type_id' => $this->car_body_type_id,
            'car_fuel_id' => $this->car_fuel_id,
            'name' => $this->name,
            'price' => $this->price,
            'stock' => $this->stock,
            'image' => $this->image,
            'image_url' => $this->image_url,
            'description' => $this->description,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,

            'car_brand' => new CarBrandResource($this->whenLoaded('carBrand')),
            'car_body_type' => new CarBodyTypeResource($this->whenLoaded('carBodyType')),
            'car_fuel' => new CarFuelResource($this->whenLoaded('carFuel')),
            'detail_transactions' => DetailTransactionResource::collection($this->whenLoaded('detailTransactions')),
        ];
    }
}
