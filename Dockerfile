# Multi-stage build for optimized production image

# --- Stage 1: vendor ---
FROM composer:2 AS vendor
WORKDIR /app
COPY laravel/composer.json laravel/composer.lock ./
RUN composer install --no-dev --no-autoloader --prefer-dist --no-scripts

# --- Stage 2: backend ---
FROM php:8.2-fpm-alpine AS backend

# Install system dependencies including Redis
RUN apk add --no-cache \
    bash \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    oniguruma-dev \
    redis \
    php82-pecl-redis && \
    docker-php-ext-install pdo pdo_mysql zip gd opcache

# Copy Composer binary
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy vendor directory
COPY --from=vendor /app/vendor/ /var/www/html/vendor/

# Copy application code
COPY laravel/ /var/www/html/

WORKDIR /var/www/html

# Create non-root user first
RUN adduser -D -u 1000 -g www-data www-user

# Set ownership and permissions for directories Laravel needs to write
RUN chown -R www-user:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && mkdir -p storage/logs \
    && touch storage/logs/laravel.log \
    && chown www-user:www-data storage/logs/laravel.log

# Generate optimized autoloader
RUN composer dump-autoload --optimize

# Copy entrypoint
COPY railway-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

# Switch to non-root user
USER www-user

# Default command
CMD ["railway-entrypoint.sh"]
