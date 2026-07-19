# 🔥 Firebase Authentication — notes

This app uses **Firebase Authentication** (email + password) with **Continue with
Google** as the sign-in for the whole project (course rubric: Firebase Auth +
Google Sign-In bonus).

## The config is already included ✅

You do **not** need to create a Firebase project to run this. The client config
ships with the repo:

- `lib/firebase_options.dart` — web + Android/iOS options (used by
  `Firebase.initializeApp`)
- `android/app/google-services.json` — Android config (used by the Gradle
  `google-services` plugin)

These are Firebase **client** identifiers, not private secrets — Firebase security
is enforced by its own security rules and, for Android, by the app's registered
signing certificate (SHA-1). They're committed so the project is clone-and-run.

## Running

```bash
flutter pub get
flutter run          # also start the Laravel backend (see ../README.md) for data/favorites
```

- **Sign up** with any email + password → creates a real Firebase user.
- **Sign in** works for existing users; a wrong password shows a friendly error.
- **Auto-login**: once signed in, the app skips Login on the next launch.
- **Logout** is in **Settings**.
- **Continue with Google** → see the note below.

> **Email/Password works on any machine out of the box.** This is the core
> Firebase Auth requirement.

## Google Sign-In on a *new* machine (optional)

Google Sign-In on Android is tied to the app's **debug signing key**, which is
different on every computer. The bundled `google-services.json` already contains
the original dev machine's SHA-1, so Google Sign-In works there. To enable it on a
different machine:

1. Get that machine's debug SHA-1:
   ```bash
   cd android
   ./gradlew signingReport        # Windows: .\gradlew signingReport
   ```
   Copy the **SHA1** under `Variant: debug`.
2. In the [Firebase console](https://console.firebase.google.com) →
   **Project settings** → the Android app → **Add fingerprint** → paste the SHA-1
   → **Save**.
3. **Re-download `google-services.json`** and replace `android/app/google-services.json`.

(If you can't modify the Firebase project, you can still demonstrate Firebase Auth
via Email/Password; the "Continue with Google" button and its code are in
`lib/services/firebase_auth_service.dart` and `lib/screens/login_screen.dart`.)

## Pointing the app at your *own* Firebase project (optional)

If you'd rather use your own project, run the FlutterFire CLI — it regenerates
both config files for you:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Then enable **Email/Password** and **Google** under
Firebase console → **Build → Authentication → Sign-in method**.

## How auth ties into the backend

- **Firebase** is the source of truth for *who is logged in*.
- After a Firebase sign-in the app calls **`POST /api/v1/auth/social`**
  (email + Firebase UID) to get a Sanctum token, so **favorites & profile still
  work** per-user against the Laravel backend. This bridge is non-fatal: if the
  backend is offline you stay logged in and public data still loads — only
  favorites need the token.

## Troubleshooting

- **"No Firebase App '[DEFAULT]'" on launch:** `android/app/google-services.json`
  is missing or misplaced. It must be exactly at `android/app/google-services.json`.
- **Google sign-in fails / ID token is null:** the current machine's SHA-1 isn't
  registered (see above), or `google-services.json` wasn't re-downloaded after
  adding it.
- **`Duplicate class` / minSdk errors:** this project sets `minSdk 23` (Firebase
  requires it) in `android/app/build.gradle.kts`.
