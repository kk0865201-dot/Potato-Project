# Deploying the backend (free, ~5 minutes)

The Flutter app is preconfigured to call a live backend at
**`https://potato-api-kk0865201.onrender.com`**. This guide deploys the Laravel API
(`backend/`) to that URL on **Render's free tier** (no credit card required).

Everything needed is already in the repo:
- `backend/Dockerfile` — builds the API image
- `backend/docker-entrypoint.sh` — creates + seeds the database, then starts the server
- `render.yaml` — the one-click Blueprint (service name, plan, env vars)

---

## Steps

### 1. Push this repo to GitHub
(You'll do this anyway for submission.)

```bash
cd Potato-Project
git remote add origin https://github.com/kk0865201-dot/Potato-Project.git
git push -u origin main
```

### 2. Create a Render account
Go to **<https://render.com>** → **Get Started** → **Sign in with GitHub** (free,
no card). Authorize Render to see your repositories.

### 3. Deploy the Blueprint
1. In the Render dashboard, click **New ►** → **Blueprint**.
2. Select your **Potato-Project** repository.
3. Render reads `render.yaml` and shows one service: **potato-api-kk0865201**.
4. Click **Apply**.

Render now builds the Docker image and deploys (first build ≈ 3–5 min). You can
watch the log; a successful boot ends with `Server running on … :10000`.

### 4. Get your URL
When it's live, the service URL (top of the service page) will be:

```
https://potato-api-kk0865201.onrender.com
```

**Verify it works** — open this in a browser:

```
https://potato-api-kk0865201.onrender.com/api/v1/varieties
```

You should get JSON starting with `{"success":true,...}`. (The first hit may take
~50s while it wakes up — that's normal for the free tier.)

### 5. If your URL is different
If Render gave the service a different name/URL (e.g. the name was taken), just
tell me the real URL — or edit one line yourself:

`mobile/lib/constants/api_constants.dart` →
```dart
static const String _productionBaseUrl = 'https://YOUR-URL.onrender.com';
```
then `git commit -am "point app at deployed API" && git push`.

---

## Good to know

- **Free tier sleeps** after ~15 min of inactivity. The next request wakes it
  (~50s), then it's fast again. The app's request timeout is set to 60s to cover
  this, and the Home screen has a pull-to-refresh + retry if a cold start times out.
- **The database is re-seeded on every boot** (fresh SQLite each time), so
  varieties and recipes are always present. Favorites created during a session
  persist until the service restarts.
- **Auto-deploy is on**: pushing to `main` triggers a new deploy automatically.
- **Logs**: the service's *Logs* tab streams everything (`LOG_CHANNEL=stderr`).

## Alternatives
The same `Dockerfile` runs on **Railway**, **Koyeb**, or **Fly.io** — point the
platform at the `backend/` directory and set the same environment variables from
`render.yaml`.
