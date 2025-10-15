#!/usr/bin/env bash
set -e

echo "[init.sh] Initializing Laravel environment..."

# Copy .env if missing
if [ ! -f laravel/.env ]; then
  cp laravel/.env.example laravel/.env
  echo "[init.sh] .env file created from example"
fi

# Generate key if not set
cd laravel
if ! grep -q "APP_KEY=" .env || [ -z "$(grep 'APP_KEY=' .env | cut -d= -f2)" ]; then
  php artisan key:generate --force
  echo "[init.sh] App key generated"
fi

echo "[init.sh] Initialization complete."