<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\VarietyResource;
use App\Models\Variety;
use App\Support\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class VarietyController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Variety::query()->ordered();

        if ($search = trim((string) $request->query('search'))) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('type', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%")
                    ->orWhere('best_for', 'like', "%{$search}%");
            });
        }

        $perPage = min(max((int) $request->query('per_page', 10), 1), 50);
        $paginator = $query->paginate($perPage);

        return ApiResponse::paginated(
            VarietyResource::collection(collect($paginator->items())),
            $paginator,
            'Varieties loaded successfully'
        );
    }

    public function show(Variety $variety): JsonResponse
    {
        return ApiResponse::success(
            new VarietyResource($variety),
            'Variety loaded successfully'
        );
    }
}
