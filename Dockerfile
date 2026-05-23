# ---------- Frontend Build ----------
FROM node:20 AS frontend

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# ---------- Backend ----------
FROM php:8.3-apache

WORKDIR /var/www/html

# Install system packages
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Enable apache rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel app
COPY . .

# Copy built Vite assets
COPY --from=frontend /app/public/build ./public/build

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
