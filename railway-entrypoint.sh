#!/bin/sh
set -e

echo "🚀 Starting application deployment..."


echo "🔧 Testing Laravel boot..."
php artisan tinker --execute="echo 'Laravel boots successfully';"

echo "🔧 Testing routes..."
php artisan route:list

echo "🏁 Starting PHP server..."
exec php artisan serve --host=0.0.0.0 --port=$PORT &


# --- Wait for MySQL ---
echo "🔍 Checking MySQL connectivity..."
RETRIES=15
COUNT=0
until php -r 'new PDO("mysql:host=" . getenv("DB_HOST") . ";port=" . getenv("DB_PORT"), getenv("DB_USERNAME"), getenv("DB_PASSWORD"));' >/dev/null 2>&1; do
  COUNT=$((COUNT+1))
  echo "Waiting for database... ($COUNT/$RETRIES)"
  if [ "$COUNT" -ge "$RETRIES" ]; then
    echo "❌ Database unreachable after $RETRIES attempts"; exit 1
  fi
  sleep 2
done
echo "✅ Database is reachable"

# --- Wait for Redis (optional) ---
if [ -n "${REDISHOST}" ] && [ -n "${REDISPORT}" ]; then
  echo "🔍 Checking Redis connection..."
  COUNT=0
  until redis-cli -h "$REDISHOST" -p "$REDISPORT" -a "$REDISPASSWORD" ping 2>/dev/null | grep -q PONG; do
    COUNT=$((COUNT+1))
    echo "Waiting for Redis... ($COUNT/$RETRIES)"
    if [ "$COUNT" -ge "$RETRIES" ]; then
      echo "❌ Redis unreachable after $RETRIES attempts"; exit 1
    fi
    sleep 2
  done
  echo "✅ Redis is ready"
else
  echo "⚠️ Redis not configured, skipping Redis check"
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