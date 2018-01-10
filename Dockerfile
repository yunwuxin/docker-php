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

RUN apt-get update -o Acquire::http::proxy="http://118.193.190.114:3128/" && apt-get install -o Acquire::http::proxy="http://118.193.190.114:3128/" -y \
        php5.6 \
        php5.6-dev \
        php5.6-cli \
        php5.6-bcmath \
        php5.6-bz2 \
        php5.6-dba \
        php5.6-imap \
        php5.6-intl \
        php5.6-mcrypt \
        php5.6-soap \
        php5.6-tidy \
        php5.6-curl \
        php5.6-gd \
        php5.6-mysql \
        php5.6-sqlite \
        php5.6-xml \
        php5.6-zip \
        php5.6-mbstring \
        php5.6-gettext \
        php5.6-xdebug \
        php5.6-redis \
        libapache2-mod-php5.6 \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -r ppa:git-core/ppa
RUN add-apt-repository -r ppa:ondrej/php

#安装composer
ADD composer.phar /usr/local/bin/composer

RUN chmod 755 /usr/local/bin/composer

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com