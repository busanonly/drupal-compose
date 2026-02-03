FROM drupal:11-apache

RUN apt-get update && apt-get install -y \
  git unzip libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
  libonig-dev libxml2-dev libicu-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd zip intl opcache \
  && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Ubah Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT=/var/www/html/cms/web
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
