#!/bin/sh
set -e

echo "🚀 Starting application deployment..."

# Generate key first
if [ -z "${APP_KEY}" ] || [ "${APP_KEY}" = "base64:null" ]; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force
fi

# Run migrations and seed FIRST
echo "🔄 Running database migrations..."
php artisan migrate --force

echo "🌱 Seeding database..."
php artisan db:seed --force

# Debug routes and boot
echo "🔧 Testing Laravel boot..."
php artisan tinker --execute="echo 'Laravel boots successfully';"

echo "🔧 Testing routes..."
php artisan route:list

# Quick connectivity checks
echo "🔍 Checking database connectivity..."
timeout 10 bash -c 'until php -r "new PDO(\"mysql:host=\".getenv(\"DB_HOST\").\";port=\".getenv(\"DB_PORT\").\", getenv(\"DB_USERNAME\"), getenv(\"DB_PASSWORD\"));" 2>/dev/null; do echo "Waiting for database..."; sleep 1; done'
echo "✅ Database connected"

if [ -n "${REDISHOST}" ] && [ -n "${REDISPORT}" ]; then
    echo "🔍 Checking Redis..."
    timeout 10 bash -c 'until redis-cli -h $REDISHOST -p $REDISPORT -a "$REDISPASSWORD" ping | grep -q PONG; do echo "Waiting for Redis..."; sleep 1; done'
    echo "✅ Redis connected"
fi

# Optimize
echo "⚙️ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✅ Application is ready!"
exec php artisan serve --host=0.0.0.0 --port=$PORT