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
        if (strpos($this->image, 'http') === 0) {
            $imageUrl = $this->image;
        } else if (!$this->image) {
            $imageUrl = asset('storage/images/admins/' . $this->image);
        }

        // joined at
        return [
            'id' => $this->id,
            'name' => $this->name,
            'image' => $imageUrl,
            'email' => $this->email,
            'isSuperAdmin' => $this->isSuperAdmin,
            'createdAt' => $this->created_at,
            'joinedAt' => $this->created_at->diffForHumans(),
            'updatedAt' => $this->updated_at,
        ];
    }
}
