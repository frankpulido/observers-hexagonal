#!/bin/sh
set -e

echo "🚀 Starting application deployment..."

# Wait for Redis
if command -v redis-cli >/dev/null 2>&1; then
    echo "🔍 Checking Redis connection..."
    timeout 30 bash -c 'until redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD ping | grep -q PONG; do echo "Waiting for Redis..."; sleep 2; done'
    echo "✅ Redis is ready"
fi

# Wait for MySQL
echo "🔍 Checking MySQL connection..."
timeout 30 bash -c 'until php artisan db:monitor > /dev/null 2>&1; do echo "Waiting for database connection..."; sleep 2; done'
echo "✅ Database is ready"

# Generate key only if not set or is the default null value
if [ -z "${APP_KEY}" ] || [ "${APP_KEY}" = "base64:null" ]; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force
fi

# Optimize for production
echo "⚙️ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations
echo "🔄 Running database migrations..."
php artisan migrate --force

echo "✅ Application is ready!"
exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}