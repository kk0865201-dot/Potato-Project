<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

/**
 * Serves the app's media (potato photos + the 3D model) through the API so the
 * mobile/web client is fully API-driven.
 *
 * Why route it instead of serving the static files under /assets directly:
 * static files are handled by the web server and bypass Laravel's CORS
 * middleware, but the Flutter web build and the 3D-model WebView both enforce
 * CORS. Because this route lives under `api/*`, `config/cors.php` adds the
 * `Access-Control-Allow-Origin` header, so the media loads everywhere.
 */
class MediaController extends Controller
{
    public function show(Request $request, string $path): BinaryFileResponse
    {
        // Resolve inside public/assets and reject anything that escapes it.
        $base = realpath(public_path('assets'));
        $full = realpath(public_path('assets/'.$path));

        abort_if(
            $base === false || $full === false || ! str_starts_with($full, $base) || ! is_file($full),
            404,
            'Media not found.'
        );

        $types = [
            'jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png',
            'gif' => 'image/gif', 'webp' => 'image/webp', 'svg' => 'image/svg+xml',
            'glb' => 'model/gltf-binary', 'gltf' => 'model/gltf+json',
        ];
        $ext = strtolower(pathinfo($full, PATHINFO_EXTENSION));

        $headers = ['Cache-Control' => 'public, max-age=86400'];
        if (isset($types[$ext])) {
            $headers['Content-Type'] = $types[$ext];
        }

        // BinaryFileResponse streams the file and supports HTTP Range requests
        // (which <model-viewer> uses when fetching the .glb).
        return response()->file($full, $headers);
    }
}
