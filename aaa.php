# ./Dockerfile
FROM dunglas/frankenphp:php8.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git && \
    docker-php-ext-install pdo_mysql zip && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Laravel app
COPY ./laravel /app

# Copy nginx config if needed
COPY ./nginx/conf.d/default.conf /etc/caddy/Caddyfile

# Install composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Cache Laravel config, routes, and views
RUN php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

EXPOSE 8080
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
