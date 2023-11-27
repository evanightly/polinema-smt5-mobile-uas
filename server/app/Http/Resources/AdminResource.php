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
            'is_super_admin' => $this->isSuperAdmin,
            'image' => $this->image,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,

            // custom attributes used in view
            'image_url' => $this->image_url,
            'joined_at' => $this->created_at->format('d M Y'),
            'is_super_admin_label' => $this->isSuperAdmin ? 'Yes' : 'No',
        ];
    }
}
