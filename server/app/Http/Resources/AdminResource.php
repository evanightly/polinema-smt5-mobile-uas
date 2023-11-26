<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AdminResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        // joined at
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'password' => $this->password,
            'isSuperAdmin' => $this->isSuperAdmin,
            'image' => $this->image,
            'createdAt' => $this->created_at,
            'updatedAt' => $this->updated_at,

            // custom attributes used in view
            'imageUrl' => $this->imageUrl,
            'joinedAt' => $this->created_at->format('d M Y'),
            'isSuperAdminLabel' => $this->isSuperAdmin ? 'Yes' : 'No',
        ];
    }
}
