<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Sets the app locale for API responses from the mobile client's
 * `Accept-Language` header (or a `?lang=` query override). Only the locales
 * the app actually ships translations for are honoured.
 */
class SetLocale
{
    private const SUPPORTED = ['en', 'ar'];

    public function handle(Request $request, Closure $next): Response
    {
        $locale = $request->query('lang')
            ?? $request->getPreferredLanguage(self::SUPPORTED);

        // getPreferredLanguage returns e.g. "en"; normalise "ar-SA" -> "ar".
        $locale = strtolower(substr((string) $locale, 0, 2));

        if (in_array($locale, self::SUPPORTED, true)) {
            app()->setLocale($locale);
        }

        return $next($request);
    }
}
