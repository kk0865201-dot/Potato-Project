<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreFavoriteRequest;
use App\Http\Resources\VarietyResource;
use App\Models\Variety;
use App\Support\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $favorites = $request->user()->favorites()->ordered()->get();

        return ApiResponse::success(
            VarietyResource::collection($favorites),
            'Favorites loaded successfully'
        );
    }

    public function store(StoreFavoriteRequest $request): JsonResponse
    {
        $varietyId = $request->validated('variety_id');

        $request->user()->favorites()->syncWithoutDetaching([$varietyId]);

        return ApiResponse::success(
            new VarietyResource(Variety::findOrFail($varietyId)),
            'Added to favorites',
            201
        );
    }

    public function destroy(Request $request, Variety $variety): JsonResponse
    {
        $request->user()->favorites()->detach($variety->id);

        return ApiResponse::success(null, 'Removed from favorites');
    }
}
