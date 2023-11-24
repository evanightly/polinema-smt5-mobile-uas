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
        if (strpos($this->image, 'http') === 0) {
            $imageUrl = $this->image;
        } else if (!$this->image) {
            $imageUrl = asset('storage/images/payment_proof/' . $this->image);
        }

        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'status' => $this->status,
            'total' => $this->total,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'payment_method' => $this->payment_method,
            'payment_proof' => $imageUrl,
            'payment_date' => $this->payment_date,
            'delivery_address' => $this->delivery_address,
            'verified_at' => $this->verified_at,
            'detail_transactions' => DetailTransactionResource::collection($this->detailTransactions),
            'user' => new UserResource($this->user),
            'verifiedBy' =>  new AdminResource($this->verifiedBy)
        ];
    }
}
