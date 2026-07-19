<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

class Nutrient extends Model
{
    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'is_major' => 'boolean',
            'is_thick' => 'boolean',
            'indented' => 'boolean',
            'show_bar' => 'boolean',
        ];
    }

    public function scopeOrdered(Builder $query): Builder
    {
        return $query->orderBy('sort_order');
    }
}
