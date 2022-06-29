FROM php:8.1-fpm

RUN apt-get update && apt-get -q -y install \
    apt-utils \
    vim \
    sudo\
    git \
    mariadb-client \
    curl \
    zip \
    unzip \
    cron \
    supervisor \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libicu-dev \
    libxslt-dev \
    libaio1 \
    libzip-dev \
    libarchive-tools \
    gnupg \
    wget \
    openssh-server && \
    pecl -q install xdebug-3.1.4 && \
    docker-php-ext-install -j$(nproc) iconv && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd curl zip pdo_mysql bcmath soap intl xsl

RUN wget https://getcomposer.org/download/2.3.5/composer.phar
RUN mv composer.phar /usr/bin/composer
RUN chmod a+x /usr/bin/composer

RUN mkdir /var/run/sshd

RUN groupadd --gid 1000 app
RUN useradd app --uid 1000 -m -g app
RUN adduser app sudo
RUN echo "app:app" | chpasswd


RUN useradd xdebug -m
RUN adduser xdebug sudo
RUN echo "xdebug:xdebug" | chpasswd

COPY supervisor_app.conf /etc/supervisor/conf.d/
RUN sed 's@session\s*required\s*pam_loginuid.so@ion optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY php-xdebug.ini /usr/local/etc/php/conf.d
COPY php.ini /usr/local/etc/php

RUN sed -i 's/user = www-data/user = app/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group = www-data/group = app/' /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install sockets

RUN mkdir /var/www/php

VOLUME /var/www/php
WORKDIR /var/www/php

RUN chmod g+s /var/www/php

RUN chmod 666 /tmp/xdebug.log

RUN ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

RUN echo "postfix postfix/mailname string magento.local.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
RUN apt-get -y -q install postfix

COPY main.cf /etc/postfix
COPY postfix-init.sh /etc/postfix
RUN chmod +x /etc/postfix/postfix-init.sh

ENV MAGENTO_RUN_MODE developer

EXPOSE 9000 9009 22

CMD ["supervisord", "-n"]
