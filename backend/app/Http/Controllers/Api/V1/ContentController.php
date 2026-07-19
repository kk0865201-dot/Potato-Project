<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\GrowingStepResource;
use App\Http\Resources\NutrientResource;
use App\Http\Resources\RecipeResource;
use App\Http\Resources\TimelineEventResource;
use App\Http\Resources\VarietyResource;
use App\Models\GrowingStep;
use App\Models\Nutrient;
use App\Models\Recipe;
use App\Models\TimelineEvent;
use App\Models\Variety;
use App\Support\ApiResponse;
use Illuminate\Http\JsonResponse;

class ContentController extends Controller
{
    private const NUTRITION_SERVING = 'One medium potato, baked with skin (173 g)';

    public function nutrition(): JsonResponse
    {
        return ApiResponse::success([
            'serving' => self::NUTRITION_SERVING,
            'nutrients' => NutrientResource::collection(Nutrient::ordered()->get()),
        ], 'Nutrition facts loaded successfully');
    }

    public function history(): JsonResponse
    {
        return ApiResponse::success(
            TimelineEventResource::collection(TimelineEvent::ordered()->get()),
            'History timeline loaded successfully'
        );
    }

    public function growing(): JsonResponse
    {
        return ApiResponse::success(
            GrowingStepResource::collection(GrowingStep::ordered()->get()),
            'Growing guide loaded successfully'
        );
    }

    /**
     * Single bootstrap payload for the mobile app: everything in one request.
     */
    public function overview(): JsonResponse
    {
        return ApiResponse::success([
            'varieties' => VarietyResource::collection(Variety::ordered()->get()),
            'recipes' => RecipeResource::collection(Recipe::ordered()->get()),
            'nutrition' => [
                'serving' => self::NUTRITION_SERVING,
                'nutrients' => NutrientResource::collection(Nutrient::ordered()->get()),
            ],
            'history' => TimelineEventResource::collection(TimelineEvent::ordered()->get()),
            'growing' => GrowingStepResource::collection(GrowingStep::ordered()->get()),
        ], 'Overview loaded successfully');
    }
}
