<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartResource extends JsonResource
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
            'quantity' => $this->quantity,
            'subtotal' => $this->subtotal,
            'user' => new UserResource($this->whenLoaded('user')),
            'car' => new CarResource($this->whenLoaded('car')),
            'formatted_subtotal' => $this->formattedSubtotal,
        ];
    }
}
