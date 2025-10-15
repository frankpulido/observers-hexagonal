# Multi-stage build for optimized production image
FROM composer:2 AS vendor
WORKDIR /app
COPY laravel/composer.json laravel/composer.lock ./
RUN composer install --no-dev --no-autoloader --prefer-dist --no-scripts

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

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy vendor directory
COPY --from=vendor /app/vendor/ /var/www/html/vendor/

# Copy application code
COPY laravel/ /var/www/html/

WORKDIR /var/www/html

# Generate optimized autoloader and set permissions
RUN composer dump-autoload --optimize \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Create non-root user
RUN adduser -D -u 1000 -g www-data www-user

# Copy entrypoint to user's home directory
COPY railway-entrypoint.sh /home/www-user/
RUN chmod +x /home/www-user/railway-entrypoint.sh

# Switch to non-root user
USER www-user

EXPOSE 8000

CMD ["/home/www-user/railway-entrypoint.sh"]