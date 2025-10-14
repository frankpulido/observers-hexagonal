# Railway build for Laravel + Nginx using FrankenPHP
FROM dunglas/frankenphp:php8.2

# Install dependencies for Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git \
    && docker-php-ext-install pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Laravel source
COPY ./laravel /app

# Copy Nginx config to FrankenPHP (Caddyfile)
COPY ./nginx/conf.d/default.conf /etc/caddy/Caddyfile

# Install Composer (FrankenPHP doesn’t have it by default)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Cache config and routes
RUN php artisan config:cache && php artisan route:cache

EXPOSE 80

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]