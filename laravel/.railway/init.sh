#!/usr/bin/env bash
set -e

echo "[init.sh] Initializing Laravel environment..."

# Ensure dependencies exist
composer install --no-dev --optimize-autoloader && php artisan serve --host=0.0.0.0 --port=$PORT
# run migrations and seed the database
php artisan migrate:fresh --force --seed

echo "[init.sh] Initialization complete."