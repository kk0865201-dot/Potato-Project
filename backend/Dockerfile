# Laravel API for the Potato Project.
# Portable Docker image — runs on Render (free tier), Railway, Koyeb, Fly.io, etc.
FROM php:8.3-cli

# System libraries + the PHP extensions Laravel needs (SQLite, mbstring, bcmath, zip).
RUN apt-get update && apt-get install -y --no-install-recommends \
        git unzip libsqlite3-dev libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_sqlite mbstring bcmath zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer (copied from the official Composer image).
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Install PHP dependencies first so Docker can cache this layer.
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts --no-autoloader

# Copy the application source and finish the optimized autoloader.
COPY . .
RUN composer dump-autoload --optimize --no-dev --no-scripts \
    && sed -i 's/\r$//' docker-entrypoint.sh \
    && chmod +x docker-entrypoint.sh

# The host injects $PORT; default to 10000 for local `docker run`.
ENV PORT=10000
EXPOSE 10000

CMD ["./docker-entrypoint.sh"]
