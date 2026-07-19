# The Potato Project — REST API (v1)

Base URL: `http://<host>/api/v1` (e.g. `http://localhost:8000/api/v1` with `php artisan serve`).

Every response uses the same JSON envelope, and endpoints are rate-limited (60 requests/min per IP, Laravel's default `api` throttle). Image URLs are absolute, so a mobile client can load them directly. CORS is open for `api/*` (Laravel default), so browser-based clients work too.

```json
// Success
{ "success": true,  "message": "Varieties loaded successfully", "data": [...], "meta": {...}? }

// Error (401 / 403 / 404 / 422 / 429 / 500)
{ "success": false, "message": "Human-readable message", "errors": {"field": ["..."]}? }
```

`meta` appears only on paginated lists: `current_page`, `last_page`, `per_page`, `total`.

## Public endpoints

| Endpoint | Returns |
|---|---|
| `POST /auth/register` | Create an account. Body: `name`, `email`, `phone?`, `password`, `password_confirmation`. Returns `{user, token}` (201) |
| `POST /auth/login` | Log in. Body: `email`, `password`. Returns `{user, token}`; wrong credentials → 401 |
| `POST /auth/guest` | No body. One-tap demo access — always signs into the same shared "Potato" account. Returns `{user, token}` |
| `GET /overview` | Everything below in one payload — ideal for app bootstrap / offline cache |
| `GET /varieties` | Potato varieties. Supports `?search=`, `?page=`, `?per_page=` (default 10, max 50) |
| `GET /varieties/{slug}` | One variety (e.g. `/varieties/russet`), 404 if unknown |
| `GET /recipes` | Recipes with ingredients and steps. Supports `?search=`, `?page=`, `?per_page=` |
| `GET /recipes/{slug}` | One recipe (e.g. `/recipes/mashed`) |
| `GET /nutrition` | Serving description + nutrient rows |
| `GET /history` | Timeline events, oldest first |
| `GET /growing` | Growing guide steps, ordered 1–7 |

## Protected endpoints (Sanctum)

Send the token from register/login as `Authorization: Bearer <token>`. Missing/expired token → 401.

| Endpoint | Returns |
|---|---|
| `POST /auth/logout` | Revokes the current token |
| `GET /auth/user` | The authenticated user's profile |
| `PUT /auth/profile` | Update profile. Body (all optional): `name`, `email`, `phone`, `password` + `password_confirmation` |
| `GET /favorites` | The user's favorite varieties (full Variety objects) |
| `POST /favorites` | Add a favorite. Body: `variety_id`. Idempotent. Returns the variety (201) |
| `DELETE /favorites/{id}` | Remove a favorite by variety **id** |

## Shapes

**Variety** — `id`, `slug`, `name`, `type` (`Starchy` / `Waxy` / `All-purpose`), `description`, `best_for`, `origin`, `rating`, `image_url`, `image_alt`, `featured`

**Recipe** — `id`, `slug`, `title`, `summary`, `tag`, `serves`, `prep_time`, `cook_time`, `best_potato`, `image_url`, `image_alt`, `featured`, `ingredients[]`, `steps[]`

**User** — `id`, `name`, `email`, `phone`, `created_at`

**Nutrition** — `serving` (string), `nutrients[]` of `name`, `amount`, `percent_dv` (nullable)

**History event** — `date` (display label, e.g. `"c. 8000 BCE"`), `description`

**Growing step** — `step` (1–7), `title`, `description`

Example:

```json
GET /api/v1/varieties/russet

{
  "success": true,
  "message": "Variety loaded successfully",
  "data": {
    "id": 1,
    "slug": "russet",
    "name": "Russet",
    "type": "Starchy",
    "description": "Thick netted brown skin, dry fluffy flesh. ...",
    "best_for": "baking, mashing, fries",
    "origin": "North America",
    "rating": 4.8,
    "image_url": "http://localhost:8000/assets/photos/russet.jpg",
    "image_alt": "Russet potatoes with sprouts",
    "featured": true
  }
}
```

## Notes for the mobile app

- `featured: true` marks the items shown on the web home page — the app uses it for the "Featured" carousel.
- Content lives in the database (seeded by `database/seeders/ContentSeeder.php`); edit/reseed there and both web and API update together.
- Favorites live server-side in the `favorites` pivot table (unique per user+variety), so they sync across devices.
- Run the test suite with `php artisan test` (covers every endpoint, auth, favorites, and page).
