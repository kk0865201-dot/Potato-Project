<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Variety;
use Database\Seeders\ContentSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthFavoritesTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(ContentSeeder::class);
    }

    private function registerPayload(array $overrides = []): array
    {
        return array_merge([
            'name' => 'Spud Lover',
            'email' => 'spud@example.com',
            'phone' => '0790000000',
            'password' => 'secret123',
            'password_confirmation' => 'secret123',
        ], $overrides);
    }

    public function test_register_creates_user_and_returns_token(): void
    {
        $response = $this->postJson('/api/v1/auth/register', $this->registerPayload())
            ->assertCreated()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.user.email', 'spud@example.com')
            ->assertJsonStructure(['success', 'message', 'data' => ['user' => ['id', 'name', 'email', 'phone'], 'token']]);

        $this->assertNotEmpty($response->json('data.token'));
        $this->assertDatabaseHas('users', ['email' => 'spud@example.com']);
    }

    public function test_register_validates_input_with_standardized_422(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload(['email' => 'not-an-email']))
            ->assertUnprocessable()
            ->assertJsonPath('success', false)
            ->assertJsonStructure(['success', 'message', 'errors' => ['email']]);
    }

    public function test_register_rejects_duplicate_email(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload())->assertCreated();

        $this->postJson('/api/v1/auth/register', $this->registerPayload())
            ->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_login_returns_token_for_valid_credentials(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload())->assertCreated();

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'spud@example.com',
            'password' => 'secret123',
        ])
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.user.name', 'Spud Lover');

        $this->assertNotEmpty($response->json('data.token'));
    }

    public function test_login_rejects_wrong_password_with_401(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload())->assertCreated();

        $this->postJson('/api/v1/auth/login', [
            'email' => 'spud@example.com',
            'password' => 'wrong-password',
        ])
            ->assertUnauthorized()
            ->assertJsonPath('success', false);
    }

    public function test_guest_login_returns_a_potato_user_and_token(): void
    {
        $response = $this->postJson('/api/v1/auth/guest')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.user.name', 'Potato')
            ->assertJsonStructure(['success', 'message', 'data' => ['user' => ['id', 'name', 'email'], 'token']]);

        $this->assertNotEmpty($response->json('data.token'));
        $this->assertDatabaseCount('users', 1);
    }

    public function test_guest_login_reuses_the_same_account_every_time(): void
    {
        $first = $this->postJson('/api/v1/auth/guest')->assertOk();
        $second = $this->postJson('/api/v1/auth/guest')->assertOk();

        $this->assertSame($first->json('data.user.id'), $second->json('data.user.id'));
        $this->assertNotSame($first->json('data.token'), $second->json('data.token'));
        $this->assertDatabaseCount('users', 1);
    }

    public function test_guest_token_can_access_protected_endpoints(): void
    {
        $token = $this->postJson('/api/v1/auth/guest')->json('data.token');

        $this->withToken($token)
            ->getJson('/api/v1/auth/user')
            ->assertOk()
            ->assertJsonPath('data.name', 'Potato');
    }

    public function test_social_bridge_creates_user_and_returns_token(): void
    {
        $response = $this->postJson('/api/v1/auth/social', [
            'name' => 'Firebase Fan',
            'email' => 'fb@example.com',
            'firebase_uid' => 'uid-abc-123',
        ])
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.user.email', 'fb@example.com')
            ->assertJsonStructure(['data' => ['user' => ['id', 'name', 'email'], 'token']]);

        $this->assertNotEmpty($response->json('data.token'));
        $this->assertDatabaseHas('users', ['email' => 'fb@example.com']);
    }

    public function test_social_bridge_reuses_existing_account_by_email(): void
    {
        $first = $this->postJson('/api/v1/auth/social', [
            'name' => 'Firebase Fan', 'email' => 'fb@example.com', 'firebase_uid' => 'uid-1',
        ])->assertOk();

        $second = $this->postJson('/api/v1/auth/social', [
            'name' => 'Firebase Fan', 'email' => 'fb@example.com', 'firebase_uid' => 'uid-1',
        ])->assertOk();

        $this->assertSame($first->json('data.user.id'), $second->json('data.user.id'));
        $this->assertDatabaseCount('users', 1);
    }

    public function test_social_bridge_token_can_access_favorites(): void
    {
        $token = $this->postJson('/api/v1/auth/social', [
            'email' => 'fb@example.com', 'firebase_uid' => 'uid-1',
        ])->json('data.token');

        $variety = Variety::where('slug', 'russet')->firstOrFail();

        $this->withToken($token)
            ->postJson('/api/v1/favorites', ['variety_id' => $variety->id])
            ->assertCreated();

        $this->withToken($token)
            ->getJson('/api/v1/favorites')
            ->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_social_bridge_validates_email(): void
    {
        $this->postJson('/api/v1/auth/social', ['firebase_uid' => 'uid-1'])
            ->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_authenticated_user_can_fetch_profile(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/v1/auth/user')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.email', $user->email);
    }

    public function test_profile_can_be_updated(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->putJson('/api/v1/auth/profile', ['name' => 'New Name', 'phone' => '0788888888'])
            ->assertOk()
            ->assertJsonPath('data.name', 'New Name')
            ->assertJsonPath('data.phone', '0788888888');
    }

    public function test_logout_revokes_the_current_token(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload())->assertCreated();

        $token = $this->postJson('/api/v1/auth/login', [
            'email' => 'spud@example.com',
            'password' => 'secret123',
        ])->json('data.token');

        $this->withToken($token)->postJson('/api/v1/auth/logout')
            ->assertOk()
            ->assertJsonPath('success', true);

        $this->assertDatabaseCount('personal_access_tokens', 1); // register token remains, login token revoked
    }

    public function test_guests_cannot_access_protected_endpoints(): void
    {
        $this->getJson('/api/v1/favorites')
            ->assertUnauthorized()
            ->assertJsonPath('success', false);

        $this->getJson('/api/v1/auth/user')->assertUnauthorized();
        $this->postJson('/api/v1/auth/logout')->assertUnauthorized();
    }

    public function test_user_can_add_list_and_remove_favorites(): void
    {
        $user = User::factory()->create();
        $variety = Variety::where('slug', 'russet')->firstOrFail();

        // Add
        $this->actingAs($user, 'sanctum')
            ->postJson('/api/v1/favorites', ['variety_id' => $variety->id])
            ->assertCreated()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.slug', 'russet');

        // Adding again is idempotent (no duplicate row)
        $this->actingAs($user, 'sanctum')
            ->postJson('/api/v1/favorites', ['variety_id' => $variety->id])
            ->assertCreated();

        $this->assertDatabaseCount('favorites', 1);

        // List
        $this->actingAs($user, 'sanctum')
            ->getJson('/api/v1/favorites')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.slug', 'russet');

        // Remove
        $this->actingAs($user, 'sanctum')
            ->deleteJson("/api/v1/favorites/{$variety->id}")
            ->assertOk()
            ->assertJsonPath('success', true);

        $this->assertDatabaseCount('favorites', 0);
    }

    public function test_adding_unknown_variety_to_favorites_returns_422(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->postJson('/api/v1/favorites', ['variety_id' => 999])
            ->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_favorites_are_scoped_per_user(): void
    {
        $userA = User::factory()->create();
        $userB = User::factory()->create();
        $variety = Variety::where('slug', 'russet')->firstOrFail();

        $this->actingAs($userA, 'sanctum')
            ->postJson('/api/v1/favorites', ['variety_id' => $variety->id])
            ->assertCreated();

        $this->actingAs($userB, 'sanctum')
            ->getJson('/api/v1/favorites')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }
}
