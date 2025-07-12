FROM php:8.3-apache

COPY ./docker/php/ /usr/local/etc/php/
COPY ./docker/apache/ /etc/apache2/sites-enabled/

# db
RUN apt-get update \
  && apt-get install -y zlib1g-dev mariadb-client vim libzip-dev \
  && docker-php-ext-install zip pdo_mysql

# gd
RUN apt-get install -y wget libjpeg-dev libfreetype6-dev
RUN apt-get install -y  libmagick++-dev \
  libmagickwand-dev \
  libpq-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libwebp-dev \
  libxpm-dev

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

# LDAP
RUN apt-get update \
  && apt-get install libldap2-dev -y \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
  && docker-php-ext-install ldap

# intl
RUN apt-get update \
  && apt-get install -y libicu-dev \
  && docker-php-ext-install intl

# xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html


