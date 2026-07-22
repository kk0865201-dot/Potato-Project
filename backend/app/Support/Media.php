<?php

namespace App\Support;

class Media
{
    /**
     * Build the API media URL for a stored `assets/...` path.
     *
     * e.g. "assets/photos/russet.jpg" → "https://host/api/v1/media/photos/russet.jpg"
     * Routing media through the API (rather than the static /assets path) means
     * the CORS headers from config/cors.php apply, so images and the 3D model
     * load on the web build and inside the 3D-model WebView.
     */
    public static function url(?string $path): ?string
    {
        if ($path === null || $path === '') {
            return null;
        }

        $relative = ltrim(preg_replace('#^/?assets/#', '', $path), '/');

        return url('api/v1/media/'.$relative);
    }
}
