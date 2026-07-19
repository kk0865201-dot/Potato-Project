<?php

namespace Tests\Feature;

use Database\Seeders\ContentSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiV1Test extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(ContentSeeder::class);
    }

    public function test_varieties_index_returns_all_varieties(): void
    {
        $this->getJson('/api/v1/varieties')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(6, 'data')
            ->assertJsonStructure([
                'success', 'message',
                'data' => [['id', 'slug', 'name', 'type', 'description', 'best_for', 'origin', 'rating', 'image_url', 'image_alt', 'featured']],
                'meta' => ['current_page', 'last_page', 'per_page', 'total'],
            ]);
    }

    public function test_varieties_index_supports_search(): void
    {
        $this->getJson('/api/v1/varieties?search=russet')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.slug', 'russet');
    }

    public function test_varieties_index_supports_pagination(): void
    {
        $response = $this->getJson('/api/v1/varieties?per_page=2&page=2')->assertOk();

        $this->assertCount(2, $response->json('data'));
        $this->assertSame(2, $response->json('meta.current_page'));
        $this->assertSame(3, $response->json('meta.last_page'));
        $this->assertSame(6, $response->json('meta.total'));
    }

    public function test_variety_show_resolves_by_slug(): void
    {
        $this->getJson('/api/v1/varieties/russet')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.name', 'Russet')
            ->assertJsonPath('data.origin', 'North America')
            ->assertJsonPath('data.rating', 4.8);
    }

    public function test_variety_is_localized_to_arabic_via_accept_language(): void
    {
        $this->getJson('/api/v1/varieties/russet', ['Accept-Language' => 'ar'])
            ->assertOk()
            ->assertJsonPath('data.name', 'راسِت')
            ->assertJsonPath('data.type', 'نشوية')
            ->assertJsonPath('data.origin', 'أمريكا الشمالية');
    }

    public function test_variety_can_be_localized_via_lang_query(): void
    {
        $this->getJson('/api/v1/varieties/russet?lang=ar')
            ->assertOk()
            ->assertJsonPath('data.name', 'راسِت');
    }

    public function test_content_defaults_to_english_without_a_locale(): void
    {
        $this->getJson('/api/v1/varieties/russet')
            ->assertOk()
            ->assertJsonPath('data.name', 'Russet');
    }

    public function test_recipe_is_localized_to_arabic(): void
    {
        $this->getJson('/api/v1/recipes/mashed', ['Accept-Language' => 'ar'])
            ->assertOk()
            ->assertJsonPath('data.title', 'بطاطا مهروسة ناعمة')
            ->assertJsonPath('data.tag', 'سلق وهرس');
    }

    public function test_unknown_variety_returns_standardized_404(): void
    {
        $this->getJson('/api/v1/varieties/not-a-potato')
            ->assertNotFound()
            ->assertJsonPath('success', false)
            ->assertJsonStructure(['success', 'message']);
    }

    public function test_recipes_index_returns_all_recipes(): void
    {
        $this->getJson('/api/v1/recipes')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(5, 'data')
            ->assertJsonStructure([
                'success', 'message',
                'data' => [['id', 'slug', 'title', 'serves', 'ingredients', 'steps', 'image_url']],
                'meta' => ['current_page', 'last_page', 'per_page', 'total'],
            ]);
    }

    public function test_recipe_show_includes_ingredients_and_steps(): void
    {
        $response = $this->getJson('/api/v1/recipes/mashed')->assertOk()->assertJsonPath('success', true);

        $this->assertNotEmpty($response->json('data.ingredients'));
        $this->assertNotEmpty($response->json('data.steps'));
    }

    public function test_nutrition_endpoint_returns_serving_and_nutrients(): void
    {
        $this->getJson('/api/v1/nutrition')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.serving', 'One medium potato, baked with skin (173 g)')
            ->assertJsonCount(11, 'data.nutrients');
    }

    public function test_history_endpoint_returns_timeline(): void
    {
        $this->getJson('/api/v1/history')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(8, 'data');
    }

    public function test_growing_endpoint_returns_ordered_steps(): void
    {
        $response = $this->getJson('/api/v1/growing')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(7, 'data');

        $this->assertSame(range(1, 7), array_column($response->json('data'), 'step'));
    }

    public function test_overview_bundles_everything(): void
    {
        $this->getJson('/api/v1/overview')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonStructure(['success', 'message', 'data' => ['varieties', 'recipes', 'nutrition' => ['serving', 'nutrients'], 'history', 'growing']]);
    }
}
