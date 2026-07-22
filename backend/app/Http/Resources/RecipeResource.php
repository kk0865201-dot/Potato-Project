<?php

namespace App\Http\Resources;

use App\Support\Media;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RecipeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'slug' => $this->slug,
            'title' => $this->tr('title'),
            'summary' => $this->tr('summary'),
            'tag' => $this->tr('tag_label'),
            'serves' => $this->serves,
            'prep_time' => $this->prep_time,
            'cook_time' => $this->cook_time,
            'best_potato' => $this->tr('best_potato'),
            'image_url' => Media::url($this->image),
            'image_alt' => $this->image_alt,
            'featured' => $this->featured,
            'ingredients' => $this->tr('ingredients'),
            'steps' => $this->tr('steps'),
        ];
    }
}
