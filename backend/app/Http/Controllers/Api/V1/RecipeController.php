<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\RecipeResource;
use App\Models\Recipe;
use App\Support\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RecipeController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Recipe::query()->ordered();

        if ($search = trim((string) $request->query('search'))) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('summary', 'like', "%{$search}%")
                    ->orWhere('tag_label', 'like', "%{$search}%")
                    ->orWhere('best_potato', 'like', "%{$search}%");
            });
        }

        $perPage = min(max((int) $request->query('per_page', 10), 1), 50);
        $paginator = $query->paginate($perPage);

        return ApiResponse::paginated(
            RecipeResource::collection(collect($paginator->items())),
            $paginator,
            'Recipes loaded successfully'
        );
    }

    public function show(Recipe $recipe): JsonResponse
    {
        return ApiResponse::success(
            new RecipeResource($recipe),
            'Recipe loaded successfully'
        );
    }
}
