<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\RegisterRequest;
use App\Http\Requests\Api\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Support\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * Fixed demo account used by the "Continue as Potato" quick-access button.
     * Everyone who taps it shares this one account — that's intentional,
     * it's a no-signup demo path, not a per-device guest account.
     */
    private const GUEST_EMAIL = 'guest@potato.local';

    private const GUEST_NAME = 'Potato';

    public function register(RegisterRequest $request): JsonResponse
    {
        $user = User::create($request->validated());

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $user->createToken('mobile')->plainTextToken,
        ], 'Account created successfully', 201);
    }

    /**
     * One-tap access for the "Continue as Potato" button: no email or
     * password required, always signs into the same shared demo user.
     */
    public function guest(): JsonResponse
    {
        $user = User::firstOrCreate(
            ['email' => self::GUEST_EMAIL],
            [
                'name' => self::GUEST_NAME,
                'password' => Hash::make(Str::random(32)),
            ]
        );

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $user->createToken('guest')->plainTextToken,
        ], 'Logged in as Potato');
    }

    /**
     * Bridge for Firebase-authenticated users. The app authenticates the user
     * with Firebase, then calls this with the verified email + Firebase UID to
     * obtain a Laravel Sanctum token so the same session can authorize the
     * data endpoints (favorites, profile). The account is created on first use.
     */
    public function social(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'name' => ['nullable', 'string', 'max:255'],
            'firebase_uid' => ['required', 'string', 'max:191'],
        ]);

        $name = $data['name'] ?? null;

        $user = User::firstOrCreate(
            ['email' => $data['email']],
            [
                'name' => $name ?: 'Potato User',
                'password' => Hash::make($data['firebase_uid']),
            ]
        );

        // Keep the display name fresh if Firebase provides one.
        if (! empty($name) && $user->name !== $name) {
            $user->update(['name' => $name]);
        }

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $user->createToken('firebase')->plainTextToken,
        ], 'Authenticated successfully');
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $user = User::where('email', $request->validated('email'))->first();

        if (! $user || ! Hash::check($request->validated('password'), $user->password)) {
            return ApiResponse::error('Invalid email or password.', 401);
        }

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $user->createToken('mobile')->plainTextToken,
        ], 'Logged in successfully');
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return ApiResponse::success(null, 'Logged out successfully');
    }

    public function user(Request $request): JsonResponse
    {
        return ApiResponse::success(new UserResource($request->user()), 'Profile loaded successfully');
    }

    public function updateProfile(UpdateProfileRequest $request): JsonResponse
    {
        $user = $request->user();
        $data = $request->validated();

        if (blank($data['password'] ?? null)) {
            unset($data['password']);
        }

        $user->fill($data)->save();

        return ApiResponse::success(new UserResource($user), 'Profile updated successfully');
    }
}
