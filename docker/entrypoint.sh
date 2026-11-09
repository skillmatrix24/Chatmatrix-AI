#!/bin/sh
set -e

# Optimize Laravel cache in production
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Storage link
php artisan storage:link || true

# Start PHP-FPM in background
php-fpm -D

# Start Nginx in foreground
exec nginx -g "daemon off;"
