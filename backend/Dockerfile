# Laravel API for the Potato Project.
# Portable Docker image — runs on Render (free tier), Railway, Koyeb, Fly.io, etc.
FROM php:8.3-cli

# Install PHP extensions with the community installer, which pulls the correct
# system libraries automatically (more reliable than manual docker-php-ext-install).
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions pdo_sqlite mbstring bcmath zip intl \
    && apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer (copied from the official Composer image).
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy the whole app, then install PHP dependencies. The runtime is known-good,
# so --ignore-platform-reqs avoids a false "missing ext" failure during build.
COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts --ignore-platform-reqs \
    && sed -i 's/\r$//' docker-entrypoint.sh \
    && chmod +x docker-entrypoint.sh

# The host injects $PORT; default to 10000 for local `docker run`.
ENV PORT=10000
EXPOSE 10000

CMD ["./docker-entrypoint.sh"]
