# Laravel API for the Potato Project.
# Lives at the repo ROOT so there is no subdirectory path ambiguity for the host
# to resolve — the build context is the repo and the app source is in backend/.
# PHP 8.4: the locked deps (Symfony 8) use 8.4-only syntax, so 8.3 fails at runtime.
FROM php:8.4-cli

# Install PHP extensions with the community installer (pulls the right system libs).
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions pdo_sqlite mbstring bcmath zip intl \
    && apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer (copied from the official Composer image).
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# The Laravel app lives in backend/ — copy just that into the image.
COPY backend/ /app/

# Install PHP dependencies. Runtime is known-good, so skip the platform check.
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts --ignore-platform-reqs \
    && sed -i 's/\r$//' docker-entrypoint.sh \
    && chmod +x docker-entrypoint.sh

# The host injects $PORT; default to 10000 for local `docker run`.
ENV PORT=10000
EXPOSE 10000

CMD ["./docker-entrypoint.sh"]
