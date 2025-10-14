#!/usr/bin/env bash
set -e

echo "[init.sh] Starting initialization..."
echo "[init.sh] Copying environment variables if needed..."

# Copy .env.example to .env if missing
if [ ! -f laravel/.env ]; then
  cp laravel/.env.example laravel/.env
  echo "[init.sh] .env file created from example"
fi

echo "[init.sh] Initialization complete."
echo "[init.sh] You can now run './start.sh' to start the full environment."