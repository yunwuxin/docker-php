FROM registry.topthink.com/yunwuxin/apache:latest

RUN apt-get update && apt-get install -y \
        vim \
        software-properties-common \
        python-software-properties \
        locales

#安装git
RUN add-apt-repository ppa:git-core/ppa

RUN apt-get update && apt-get install -y \
        mysql-client-5.7 \
        git

RUN locale-gen en_GB.utf8 en_US.utf8 es_ES.utf8 de_DE.UTF-8

ENV \
  LC_ALL=en_GB.UTF-8 \
  LANG=en_GB.UTF-8 \
  LANGUAGE=en_GB.UTF-8

RUN C_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y \
        php7.1 \
        php7.1-dev \
        php7.1-cli \
        php7.1-bcmath \
        php7.1-bz2 \
        php7.1-dba \
        php7.1-imap \
        php7.1-intl \
        php7.1-mcrypt \
        php7.1-soap \
        php7.1-tidy \
        php7.1-curl \
        php7.1-gd \
        php7.1-mysql \
        php7.1-sqlite \
        php7.1-xml \
        php7.1-zip \
        php7.1-mbstring \
        php7.1-gettext \
        php7.1-xdebug \
        php7.1-redis \
        libapache2-mod-php7.1 \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -r ppa:git-core/ppa
RUN add-apt-repository -r ppa:ondrej/php

#安装composer
ADD composer.phar /usr/local/bin/composer

RUN chmod 755 /usr/local/bin/composer

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com