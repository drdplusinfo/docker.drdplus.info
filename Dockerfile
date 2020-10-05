FROM php:7.4-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000

# Install other missed extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
      mc \
      vim \
      zlib1g-dev \
      libaio-dev \
      libxml2-dev \
      librabbitmq-dev \
      curl \
      gnupg \
      libyaml-0-2 libyaml-dev \
      git \
      apt-transport-https \
      sudo \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

RUN pecl channel-update pecl.php.net \
    && pecl install yaml-2.0.4 \
    && docker-php-ext-enable yaml \
    && pecl install xdebug-2.9.0 \
    && docker-php-ext-install intl

# re-build www-data user with same user ID and group ID as a current host user (you)
RUN if getent passwd www-data ; then userdel -f www-data; fi && \
		if getent group www-data ; then groupdel www-data; fi && \
		groupadd --gid ${GROUP_ID} www-data && \
		useradd www-data --no-log-init --gid ${USER_ID} --groups www-data --home-dir /home/www-data --shell /bin/bash && \
		mkdir -p /var/www && \
		chown -R www-data:www-data /var/www && \
		mkdir -p /home/www-data && \
		chown -R www-data:www-data /home/www-data

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
	chmod +x /usr/local/bin/composer && \
  chown www-data:www-data /usr/local/bin/composer

RUN echo 'alias ll="ls -al"' >> ~/.bashrc \
    && mkdir -p /var/log/php/tracy && chown -R www-data /var/log/php && chmod +w /var/log/php

RUN echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" > /etc/apt/sources.list.d/caddy-fury.list \
		&& apt-get update && apt-get install caddy && caddy list-modules \
		&& touch /var/log/caddy && chown caddy /var/log/caddy

COPY ./_docker /

RUN chmod +x /docker.sh && chmod -R 0600 /home/www-data/.ssh/*

ENTRYPOINT ["sh", "/docker.sh"]
