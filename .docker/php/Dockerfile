# --- STAGE: BASE ---
FROM php:8.4-fpm AS base

ENV NODE_VERSION=22.0.0
ARG WWWUSER=1000
ARG WWWGROUP=1000

WORKDIR /var/www

# 1. Update & Install System Dependencies
RUN apt-get update && apt-get install -y \
    gnupg \
    gosu \
    curl \
    ca-certificates \
    zip \
    unzip \
    git \
    supervisor \
    sqlite3 \
    libcap2-bin \
    libpng-dev \
    dnsutils \
    librsvg2-bin \
    fswatch \
    ffmpeg \
    nano \
    libzip-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    fet \
    && rm -rf /var/lib/apt/lists/*

# 2. Install PHP Extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd pdo pdo_mysql opcache bcmath sockets pcntl zip intl \
    && pecl install redis \
    && docker-php-ext-enable redis

# 3. Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# 4. Setup Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY .docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# 5. Setup Supervisor
RUN mkdir -p /var/log/supervisor \
    && touch /var/log/supervisord.log /var/log/supervisord.err \
    && chown -R www-data:www-data /var/log/supervisor /var/log/supervisord.* \
    && chmod -R 777 /var/log/supervisor /var/log/supervisord.*

COPY .docker/php/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 6. Setup User
RUN groupmod -g ${WWWGROUP} www-data && \
    usermod -u ${WWWUSER} -g ${WWWGROUP} www-data

ENTRYPOINT ["/entrypoint.sh"]

# --- STAGE: DEV ---
FROM base AS dev

# Install XDebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

CMD ["supervisord", "-c", "/etc/supervisord.conf"]

# --- STAGE: PROD ---
FROM base AS prod

COPY . /var/www
COPY .docker/supervisord.conf /etc/supervisord.conf

RUN composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data /var/www

CMD ["supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 9000
