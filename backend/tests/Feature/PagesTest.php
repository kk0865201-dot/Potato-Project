<?php

namespace Tests\Feature;

use Database\Seeders\ContentSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

class PagesTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(ContentSeeder::class);
    }

    public static function pages(): array
    {
        return [
            ['/', 'Meet the'],
            ['/varieties', 'Maris Piper'],
            ['/nutrition', 'Nutrition Facts'],
            ['/recipes', 'Silky Mashed Potatoes'],
            ['/history', 'Lake Titicaca'],
            ['/growing', 'Chit the seed potatoes'],
        ];
    }

    #[DataProvider('pages')]
    public function test_page_renders_with_database_content(string $url, string $expected): void
    {
        $this->get($url)->assertOk()->assertSee($expected, false);
    }
}
