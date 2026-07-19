#!/usr/bin/env sh
# Boots the Laravel API: prepares a fresh SQLite database (seeded so the API
# always has data) and starts the server on the port the host provides.
set -e

# Runtime directories (the container filesystem is ephemeral).
mkdir -p \
  storage/framework/cache \
  storage/framework/sessions \
  storage/framework/views \
  storage/logs \
  bootstrap/cache \
  database

# Build the package manifest now that env vars are available.
php artisan package:discover --ansi || true

# Fresh ephemeral SQLite DB, migrated + seeded → varieties/recipes always present.
touch database/database.sqlite
php artisan migrate:fresh --seed --force

# Start the API. --host 0.0.0.0 so it's reachable from outside the container.
exec php artisan serve --host 0.0.0.0 --port "${PORT:-10000}"
