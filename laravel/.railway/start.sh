#!/bin/bash
set -e

# Go to Laravel app folder
cd laravel

# Ensure dependencies exist
composer install --no-interaction --prefer-dist --optimize-autoloader

# Cache Laravel configs
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations in production-safe way
php artisan migrate --force || true

echo "[start.sh] Starting Laravel development server..."
php artisan serve --host=0.0.0.0 --port=8080