<?php

use App\Support\ApiResponse;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // Behind a platform proxy (Render/Railway/etc.) that terminates TLS,
        // trust X-Forwarded-* so Laravel generates correct https:// URLs.
        $middleware->trustProxies(at: '*');

        // Localise API responses from the client's Accept-Language header.
        $middleware->api(append: [
            \App\Http\Middleware\SetLocale::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(
            fn (Request $request) => $request->is('api/*'),
        );

        // Standardized JSON error envelope for every api/* response:
        // { "success": false, "message": "...", "errors": {...}? }
        $exceptions->render(function (ValidationException $e, Request $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error($e->validator->errors()->first(), 422, $e->errors());
            }
        });

        $exceptions->render(function (AuthenticationException $e, Request $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error('Unauthenticated. Please log in.', 401);
            }
        });

        $exceptions->render(function (AccessDeniedHttpException $e, Request $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error('You are not allowed to perform this action.', 403);
            }
        });

        $exceptions->render(function (NotFoundHttpException $e, Request $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error('Resource not found.', 404);
            }
        });

        // Catch-all for production so 5xx responses keep the same envelope.
        // In debug mode Laravel's detailed JSON (with trace) is more useful.
        $exceptions->render(function (Throwable $e, Request $request) {
            if ($request->is('api/*') && ! config('app.debug')) {
                $status = $e instanceof HttpExceptionInterface ? $e->getStatusCode() : 500;
                $message = $status >= 500
                    ? 'Something went wrong on the server. Please try again later.'
                    : ($e->getMessage() ?: 'Request failed.');

                return ApiResponse::error($message, $status);
            }
        });
    })->create();
