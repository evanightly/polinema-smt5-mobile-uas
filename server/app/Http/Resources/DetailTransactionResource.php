<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DetailTransactionResource extends JsonResource
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
            'transaction_id' => $this->transaction_id,
            'car_id' => $this->car_id,
            'qty' => $this->qty,
            'car_price' => $this->car_price,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'subtotal' => $this->subtotal,
            'transaction' => new TransactionResource($this->whenLoaded('transaction')),
            'car' => new CarResource($this->whenLoaded('car'))
        ];
    }
}
