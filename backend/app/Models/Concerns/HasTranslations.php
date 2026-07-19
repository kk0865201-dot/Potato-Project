<?php

namespace App\Models\Concerns;

use Illuminate\Support\Arr;

/**
 * Lets a model carry per-locale overrides in a `translations` JSON column
 * shaped like `['ar' => ['name' => '...', 'description' => '...']]`.
 * `tr('name')` returns the translation for the current app locale, falling
 * back to the model's own (English) attribute when none exists.
 */
trait HasTranslations
{
    public function tr(string $field): mixed
    {
        $locale = app()->getLocale();
        $translated = Arr::get($this->translations ?? [], "{$locale}.{$field}");

        return ($translated === null || $translated === '')
            ? $this->{$field}
            : $translated;
    }
}
