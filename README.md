# 🥔 Potato Project — Final Mobile Application

A full-stack field-guide app for potato varieties and recipes, built for the
**Flutter Mobile Application** course. A **Flutter** client (Firebase-authenticated)
consumes a **Laravel** REST API as its single source of truth — no mock or
hardcoded data.

This repository contains **both** halves of the project:

```
Potato-Project/
├── mobile/     Flutter app  (the mobile application — what gets graded)
└── backend/    Laravel API  (the REST backend the app talks to)
```

---

## Tech stack

| Layer     | Stack |
|-----------|-------|
| Mobile    | Flutter 3 / Dart 3, Provider, Repository + Service layers, `http`, `cached_network_image`, `easy_localization`, `model_viewer_plus` |
| Auth      | **Firebase Authentication** (email/password + **Google Sign-In**), bridged to the backend for per-user data |
| Backend   | Laravel 12, Sanctum, SQLite, standardized JSON API under `/api/v1` |

---

## What it does (feature checklist)

- **Firebase Authentication** — real sign-up / sign-in / logout with email & password.
- **Continue with Google** — one-tap Google Sign-In (bonus).
- **Auto-login** — a signed-in user skips the login screen on next launch.
- **Live data from the API** — potato varieties and recipes come from Laravel
  (`GET /api/v1/varieties`, `/recipes`) with **server-side search**,
  **pagination + lazy loading**, and **pull-to-refresh**.
- **Favorites synced to the backend** — `GET/POST/DELETE /api/v1/favorites`,
  per-user, with an optimistic heart toggle everywhere (not stored only on-device).
- **Profile** — view & edit name / email / phone (`GET /auth/user`, `PUT /auth/profile`).
- **Settings** — Light/Dark theme (persisted) and **English / Arabic** localization,
  including localized API content.
- **Interactive 3D potato model** on the Home hero (`potato.glb`, drag to rotate).
- **All media is bundled** — the 3D model, logo, and photos ship inside the app
  (`mobile/assets/`), so it runs with no external CDN or network media.
- **Every network call has loading / empty / error / retry states** with friendly
  messages for no-internet, timeout, and HTTP 401 / 403 / 404 / 422 / 500.

### Clean architecture

UI never touches the network directly:

```
Screen → Provider → Repository → Service → ApiClient → Laravel API
```

`lib/` is split into `constants, models, services, repositories, providers,
screens, widgets, routes, utils` (see `mobile/README.md`).

---

## How to run

You need the **backend running first**, then the **mobile app**.

### 1. Backend (Laravel)

Requires PHP 8.2+ and Composer.

```bash
cd backend
composer install
cp .env.example .env          # Windows: copy .env.example .env
php artisan key:generate
php artisan migrate --seed     # creates SQLite DB + seeds varieties/recipes
php artisan serve --port=8000
```

The API is now at `http://localhost:8000/api/v1`. See `backend/API.md` for the
full endpoint contract.

### 2. Mobile app (Flutter)

Requires the Flutter SDK.

```bash
cd mobile
flutter pub get
flutter run
```

- On the **Android emulator**, the app reaches the host machine at `10.0.2.2:8000`
  automatically — no configuration needed.
- On a **physical device**, pass your computer's LAN IP:
  ```bash
  flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
  ```
- For the **web** build: `flutter run -d chrome` (the 3D model and all photos are
  bundled and load offline).

---

## Firebase note (please read)

The Firebase client configuration is **already included** so the project is
clone-and-run:

- `mobile/lib/firebase_options.dart` (web + Android/iOS)
- `mobile/android/app/google-services.json` (Android)

These are Firebase **client** config values (not private secrets — Firebase
security is enforced by its own rules and, for Android, the app's registered
SHA-1). They are committed so the grader doesn't have to create a Firebase project.

- **Email/Password sign-in works out of the box** on any machine.
- **Google Sign-In on Android** additionally requires *that machine's* debug SHA-1
  to be registered in the Firebase console (Google's security model ties Google
  Sign-In to the signing key). It works on the original dev machine; on a new
  machine, either add its SHA-1 in the Firebase console or grade Google Sign-In
  via the Email/Password flow + the visible "Continue with Google" button. Full
  steps are in `mobile/FIREBASE_SETUP.md`.

### How auth ties into the backend

Firebase is the source of truth for *who is logged in*. After a Firebase sign-in
the app calls **`POST /api/v1/auth/social`** (email + Firebase UID) to obtain a
Sanctum token, so **favorites and profile stay per-user** against the same
backend. This bridge is non-fatal: if the backend is offline you remain logged in
and public data still loads — only favorites need the token.

---

## Project layout

| Path | What's inside |
|------|----------------|
| `mobile/lib/` | App source (clean architecture layers) |
| `mobile/assets/` | Bundled media: `models/potato.glb`, `photos/*.jpg`, `images/logo.gif`, `translations/{en,ar}.json` |
| `mobile/README.md` | Mobile-specific readme |
| `mobile/FIREBASE_SETUP.md` | Firebase config details & how to add your own SHA-1 |
| `backend/app/`, `backend/routes/api.php` | Controllers, resources, API routes |
| `backend/database/` | Migrations, factories, seeders |
| `backend/API.md` | REST endpoint contract |
| `backend/tests/` | Feature tests (`php artisan test`) |

---

## Author

Zubair Alojali — Final Mobile Application Project.
