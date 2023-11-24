<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
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
            'user_id' => $this->user_id,
            'status' => $this->status,
            'total' => $this->total,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'detail_transactions' => DetailTransactionResource::collection($this->whenLoaded('detailTransactions')),
            'user' =>  new UserResource($this->whenLoaded('user')),
            'verifiedBy' =>  AdminResource::collection($this->whenLoaded('verifiedBy'))
        ];
    }
}
