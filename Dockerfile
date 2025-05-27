FROM php:8.3.6-apache-bookworm

# Install required system packages
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libsqlite3-dev \
    git \
    curl \
    autoconf \
    pkg-config \
    libtool \
    build-essential \
    unzip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo_sqlite

# Install Composer
COPY --from=composer:2.8.5 /usr/bin/composer /usr/bin/composer

# Copy application code
COPY . .

# Install PHP dependencies
RUN COMPOSER_PROCESS_TIMEOUT=600 composer install --prefer-dist --no-dev --no-interaction --no-progress --no-suggest

# Enable Apache rewrite
RUN a2enmod rewrite

# Apache virtual host config
COPY ./docker/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./docker/start.sh /start.sh
RUN chmod +x /start.sh

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Start Apache
ENTRYPOINT ["/start.sh"]
