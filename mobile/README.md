# Potato App — Final Mobile Application (Flutter client)

Flutter app for the Final Project, built on top of the Midterm Project. All data
(varieties, recipes, favorites, profile) comes from the Laravel backend in
`../backend` — there is no hardcoded or mock data.

> New here? Start with the **root [`../README.md`](../README.md)** for how to run
> the backend + app together, and **[`FIREBASE_SETUP.md`](FIREBASE_SETUP.md)** for
> the Firebase config details.

## Features

- **Firebase Authentication** — real sign-up / sign-in / logout (email & password)
- **Continue with Google** — Google Sign-In (bonus)
- **Auto-login** — a signed-in Firebase user skips the login screen on next launch
- Home: potato varieties from `GET /api/v1/varieties` with server-side search,
  pagination + lazy loading, pull-to-refresh, image caching
- Interactive 3D potato model (`potato.glb`) on the Home hero
- Details screen per variety with a favorite heart
- Recipes tab: `GET /api/v1/recipes` with ingredients + numbered steps
- Favorites tab: synced with the backend (`GET/POST/DELETE /api/v1/favorites`),
  optimistic heart toggle everywhere, friendly empty state
- Profile: view + edit name / email / phone (`GET /auth/user`, `PUT /auth/profile`)
- Settings: Light/Dark mode (persisted) + English/Arabic localization + logout
- Every API call has loading / error / empty / retry states; friendly messages
  for no-internet, timeout, 401, 403, 404, 422, 500
- **All media is bundled** in `assets/` (model, logo, photos) — no external CDN

## Architecture

```
lib/
  constants/     app colors, API base URL, Firebase config
  models/        Variety, Recipe, User, Paginated<T>, ApiException
  services/      ApiClient (single HTTP gateway), FirebaseAuthService, one service per resource
  repositories/  map raw API responses to typed models
  providers/     Auth, Varieties, Recipes, Favorites, Theme (Provider/ChangeNotifier)
  screens/       splash, onboarding, login, signup, main shell, home, details,
                 recipes, recipe details, favorites, settings, profile
  widgets/       AppTextField, PrimaryButton, PotatoCard, FavoriteButton, StatusView,
                 RemoteImage (bundled-asset-first), Potato3DViewer, PotatoBackground
  routes/        named route table
  utils/         Debouncer, ViewState
```

UI never talks to the network directly: **Screen → Provider → Repository →
Service → ApiClient**. Authentication is **Firebase-first**; after a Firebase
sign-in the app calls `POST /api/v1/auth/social` to get a Sanctum token so
favorites & profile stay per-user (see root README for the full explanation).

## Running

1. **Start the backend** (see `../README.md` and `../backend/API.md`):

   ```
   cd ../backend
   php artisan migrate --seed
   php artisan serve --port=8000
   ```

2. **Run the app** (Android emulator reaches the host via `10.0.2.2`, the built-in
   default):

   ```
   flutter pub get
   flutter run
   ```

   On a **physical device**, pass your computer's LAN IP:

   ```
   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
   ```

The Firebase client config (`lib/firebase_options.dart`,
`android/app/google-services.json`) is included, so email/password auth works
immediately. Google Sign-In on a new machine needs that machine's debug SHA-1 in
the Firebase console — see [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md).

> This build targets **Android** and **Web** (both verified). The `windows/`,
> `linux/`, and `macos/` desktop folders were omitted to keep the submission
> focused; run `flutter create .` to regenerate them if you ever need a desktop build.
