# 🥔 Potato Project — Final Mobile Application

A full-stack field-guide app for potato varieties and recipes, built for the
**Flutter Mobile Application** course (Final Project). A **Flutter** client
(authenticated with **Firebase**) consumes a **Laravel** REST API as its single
source of truth — no mock or hardcoded data.

This repository contains **both** halves of the project:

```
Potato-Project/
├── mobile/     Flutter app  (the mobile application — what gets graded)
└── backend/    Laravel API  (the REST backend the app consumes)
```

---

## 👩‍🏫 For the grader — quick start

The app is preconfigured to use a **live, hosted backend**, so all you need is Flutter:

```bash
cd mobile
flutter pub get
flutter run
```

Then **sign up** with any email + password (creates a real Firebase user) and you're
in — varieties, recipes, favorites and profile all load from the live API. No backend
setup required.

> ⏳ **First load may take ~50s** while the free hosting tier wakes the backend from
> idle; it's instant afterwards. Prefer to run everything yourself? See
> **[Run the backend locally](#run-the-backend-locally)**.

### Run the backend locally

*(Optional — the app already points at the live API above.)* Requires PHP 8.3+ and
Composer.

```bash
# Terminal 1 — the API
cd backend
composer install
cp .env.example .env            # Windows: copy .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --port=8000

# Terminal 2 — the app, pointed at your local API
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000   # Android emulator
# (web / iOS simulator: use http://localhost:8000)
```

Deploying your own copy of the backend? See **[DEPLOYMENT.md](DEPLOYMENT.md)**.

---

## ✅ How this maps to the marking rubric

| Rubric row (marks) | Where it is | Done |
|---|---|:--:|
| **Midterm features (10)** — splash, onboarding (first-launch only), login UI, sign-up UI, home w/ cards+images, settings (Light/Dark + EN/AR), custom widgets, clean folders | `mobile/lib/screens/`, `mobile/lib/widgets/` | ✅ |
| **Firebase Auth (9)** — sign up, sign in, logout, auto-login, wrong-credentials error | `services/firebase_auth_service.dart`, `providers/auth_provider.dart`, `screens/{login,signup,splash,settings}_screen.dart` | ✅ |
| **API page (8)** — fetch a real REST API, loading spinner, error state, modern cards with images | `screens/home_screen.dart` + `recipes_screen.dart`, `services/api_client.dart`, `widgets/{status_view,potato_card,remote_image}.dart` | ✅ |
| **Favorites (3)** — heart on every list item, add/remove via Provider, dedicated Favorites page, empty state, stays in sync everywhere | `providers/favorites_provider.dart`, `widgets/favorite_button.dart`, `screens/favorites_screen.dart` | ✅ |
| **Code quality (20)** — screens/widgets/providers/services folders, reusable widgets, explainable | whole `mobile/lib/` (see architecture below) | ✅ |
| **Bonus — Google Sign-In (2)** — "Continue with Google" via `firebase_auth` + `google_sign_in`, lands on Home | `login_screen.dart` → `auth_provider.loginWithGoogle()` → `firebase_auth_service.signInWithGoogle()` | ✅ |

### A note on the API (beyond the brief)

The brief allows *any* free public API. This project goes further: instead of a
third-party API it consumes a **custom REST API I built myself in Laravel**
(`backend/`), **deployed live** so it's reachable like any public API. It exercises
the exact same skills the API lecture teaches — `http`, `async/await`, JSON → Dart
models, loading & error states, cards with images — on top of a real backend with
authentication and per-user favorites. The app hits the live API by default; if it's
ever unreachable you'll see the graceful error/retry state instead.

---

## Tech stack

| Layer     | Stack |
|-----------|-------|
| Mobile    | Flutter 3 / Dart 3, Provider, Repository + Service layers, `http`, `cached_network_image`, `easy_localization`, `model_viewer_plus` |
| Auth      | **Firebase Authentication** (email/password + **Google Sign-In**), bridged to the backend for per-user data |
| Backend   | Laravel 13, Sanctum, SQLite, standardized JSON API under `/api/v1`, Docker-deployed |

---

## What it does (feature highlights)

- **Firebase Authentication** — real sign-up / sign-in / logout with email & password.
- **Continue with Google** — one-tap Google Sign-In (bonus).
- **Auto-login** — a signed-in user skips the login screen on next launch.
- **Live data from the API** — potato varieties and recipes with **server-side
  search**, **pagination + lazy loading**, and **pull-to-refresh**.
- **Favorites synced to the backend** — a heart on every card, per-user, with an
  optimistic toggle everywhere (not just stored on-device).
- **Profile** — view & edit name / email / phone.
- **Settings** — Light/Dark theme (persisted) and **English / Arabic** localization
  (including localized API content).
- **Interactive 3D potato model** on the Home hero (`potato.glb`, drag to rotate).
- **All media is bundled** in `mobile/assets/` — model, logo, photos — so the app
  runs with no external CDN or network media.
- **Every network call has loading / empty / error / retry states** with friendly
  messages for no-internet, timeout, and HTTP 401 / 403 / 404 / 422 / 500.

### Clean architecture

UI never touches the network directly:

```
Screen → Provider → Repository → Service → ApiClient → Laravel API
```

`mobile/lib/` is split into `constants, models, services, repositories, providers,
screens, widgets, routes, utils` (see `mobile/README.md`).

---

## Firebase note (please read)

The Firebase client configuration is **already included** so the project is
clone-and-run:

- `mobile/lib/firebase_options.dart` (web + Android/iOS)
- `mobile/android/app/google-services.json` (Android)

These are Firebase **client** config values, not private secrets — Firebase
security is enforced by its own rules and, for Android, by the app's registered
SHA-1. The course guide explicitly allows committing `google-services.json` *to a
private repo*, which this is. They're committed so the grader doesn't need to
create a Firebase project.

- **Email/Password sign-in works out of the box** on any machine.
- **Google Sign-In on Android** additionally needs *that machine's* debug SHA-1
  registered in the Firebase console (Google ties Google Sign-In to the signing
  key). It works on the original dev machine; on a new machine, either add its
  SHA-1 or grade Google Sign-In via the visible "Continue with Google" button +
  its code. Steps: `mobile/FIREBASE_SETUP.md`.

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
| `backend/tests/` | Feature tests — `php artisan test` (41 passing) |
| `backend/Dockerfile`, `render.yaml` | Container + one-click deploy config for the live API |
| `DEPLOYMENT.md` | How the backend is deployed (Render, free tier) |

---

## Author

Zubair Alojali — Final Mobile Application Project.
