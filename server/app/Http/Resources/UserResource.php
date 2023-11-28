<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'name' => $this->name,
            'email' => $this->email,
            'password' => $this->password,
            'address' => $this->address,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'transaction' =>  TransactionResource::collection($this->whenLoaded('transaction')),
            // user cart with transaction status 'On Going'
            'cart' => new TransactionResource($this->whenLoaded('cart')),

            // custom attributes used in view
            'image_url' => $this->imageUrl,
        ];
    }
}
