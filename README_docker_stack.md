# Notifier Docker stack

This folder contains a Docker setup with 5 services:
- nginx (port 8988)
- mysql (port 3700 -> 3306)
- php (php-fpm 8.2 with Laravel extensions)
- laravel (utility container to run composer/artisan tasks and a queue worker)
- react (Vite dev server on port 8989)

Quick start
1) Copy env defaults and adjust if needed
   cp .env.example .env

2) Put your Laravel app in laravel/ (the app root should contain artisan, composer.json, public/index.php, etc.). If you don’t have one yet, run locally:
   composer create-project laravel/laravel laravel

3) Put your React app in react/ (package.json, etc.). If you don’t have one yet, you can scaffold e.g. with Vite:
   npm create vite@latest react -- --template react
   mv react/* react/.* ./react  # move into the react folder if scaffolded elsewhere

4) Start the stack
   docker compose up -d --build

Services
- Nginx: http://localhost:8988 serving Laravel public/ via php-fpm
- React: http://localhost:8989 (Vite dev server)
- MySQL: localhost:3700 (use creds from .env)

Notes
- The laravel container runs composer install, key:generate, migrate, then queue:work to keep the container alive. You can change the command in docker-compose.yml if you prefer a different process (e.g., schedule, horizon, etc.).
- PHP-FPM container serves the Laravel app to nginx via fastcgi (see nginx/conf.d/default.conf).
- The React container runs npm install on first start and then npm run dev.
- Volumes
  - ./laravel is mounted into php, nginx (read-only), and laravel containers
  - ./react is mounted into the react container
