FROM php:7.2-apache

# Install other missed extensions
RUN apt-get update && apt-get install -y \
      mc \
      vim \
      zlib1g-dev \
      libaio-dev \
      libxml2-dev \
      librabbitmq-dev \
      curl \
      gnupg \
      libyaml-0-2 libyaml-dev \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN a2enmod rewrite

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

RUN pecl channel-update pecl.php.net \
    && pecl install yaml-2.0.0 \
    && docker-php-ext-enable yaml

RUN docker-php-ext-install pdo pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

RUN echo 'alias ll="ls -al"' >> ~/.bashrc \
    && mkdir -p /var/log/php/tracy && chown -R www-data /var/log/php && chmod +w /var/log/php \
    && rm /var/log/apache2/error.log && touch /var/log/apache2/error.log

EXPOSE 80
