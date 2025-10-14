#!/usr/bin/env bash
set -e

echo "[start.sh] Starting full Docker environment..."
docker compose up --build -d