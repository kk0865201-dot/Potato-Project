<?php

namespace App\Http\Controllers;

use App\Models\GrowingStep;
use App\Models\Nutrient;
use App\Models\Recipe;
use App\Models\TimelineEvent;
use App\Models\Variety;
use Illuminate\Contracts\View\View;

class PageController extends Controller
{
    public function home(): View
    {
        return view('home', [
            'featuredVarieties' => Variety::featured()->ordered()->get(),
            'featuredRecipes' => Recipe::featured()->ordered()->get(),
        ]);
    }

    public function varieties(): View
    {
        return view('varieties', [
            'varieties' => Variety::ordered()->get(),
        ]);
    }

    public function nutrition(): View
    {
        $nutrients = Nutrient::ordered()->get();

        return view('nutrition', [
            'nutrients' => $nutrients,
            'barNutrients' => $nutrients->where('show_bar', true),
        ]);
    }

    public function recipes(): View
    {
        return view('recipes', [
            'recipes' => Recipe::ordered()->get(),
        ]);
    }

    public function history(): View
    {
        return view('history', [
            'events' => TimelineEvent::ordered()->get(),
        ]);
    }

    public function growing(): View
    {
        return view('growing', [
            'steps' => GrowingStep::ordered()->get(),
        ]);
    }
}
