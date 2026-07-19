<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class VarietyResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'slug' => $this->slug,
            'name' => $this->tr('name'),
            'type' => $this->tr('type'),
            'description' => $this->tr('description'),
            'best_for' => $this->tr('best_for'),
            'origin' => $this->tr('origin'),
            'rating' => (float) $this->rating,
            'image_url' => asset($this->image),
            'image_alt' => $this->image_alt,
            'featured' => $this->featured,
        ];
    }
}
