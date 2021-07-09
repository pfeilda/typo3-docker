FROM php:7.4-apache

# install libraries and 3rd party tools
RUN apt update
RUN apt install -y --no-install-recommends \
    libpq-dev \
    libmcrypt-dev \
    libpng-dev \
    libfreetype6-dev \
    libxml2-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    graphicsmagick \
    libzip-dev
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) mysqli soap gd zip opcache intl pgsql pdo_pgsql
RUN a2enmod rewrite ssl

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/bin/composer

# add startup script
RUN mkdir /entrypoint
COPY startup.sh /entrypoint/.

# CLEANUP
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /usr/src/*

CMD ["bash", "/entrypoint/startup.sh"]