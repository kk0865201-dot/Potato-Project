<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TimelineEventResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'date' => $this->date_label,
            'description' => $this->description,
        ];
    }
}
