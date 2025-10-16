#!/bin/sh
set -e

echo "🚀 Starting application deployment..."


echo "🔧 Testing Laravel boot..."
php artisan tinker --execute="echo 'Laravel boots successfully';"

echo "🔧 Testing routes..."
php artisan route:list

echo "🏁 Starting PHP server..."
exec php artisan serve --host=0.0.0.0 --port=$PORT &


# Simple MySQL connectivity check (without checking for tables)
echo "🔍 Checking MySQL connectivity..."
timeout 30 bash -c 'until php -r "new PDO(\"mysql:host=\".getenv(\"DB_HOST\").\";port=\".getenv(\"DB_PORT\").\";dbname=\".getenv(\"DB_DATABASE\").\", getenv(\"DB_USERNAME\"), getenv(\"DB_PASSWORD\")); exit(0);" 2>/dev/null; do echo "Waiting for database..."; sleep 2; done'
echo "✅ Database is reachable"

# Wait for Redis
if [ -n "${REDISHOST}" ] && [ -n "${REDISPORT}" ]; then
    echo "🔍 Checking Redis connection..."
    timeout 30 bash -c 'until redis-cli -h $REDISHOST -p $REDISPORT -a "$REDISPASSWORD" ping | grep -q PONG; do echo "Waiting for Redis..."; sleep 2; done'
    echo "✅ Redis is ready"
else
    echo "⚠️  Redis not configured, skipping Redis check"
fi

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

echo "🌱 Seeding database..."
php artisan db:seed --force

echo "✅ Application is ready!"

# Keep the container alive
wait