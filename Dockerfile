FROM ubuntu:16.04

ADD sources.list    /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
        supervisor \
        vim \
        software-properties-common \
        python-software-properties \
        locales \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

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
        php7.2 \
        php7.2-dev \
        php7.2-cli \
        php7.2-bcmath \
        php7.2-bz2 \
        php7.2-dba \
        php7.2-imap \
        php7.2-intl \
        php7.2-mcrypt \
        php7.2-soap \
        php7.2-tidy \
        php7.2-curl \
        php7.2-gd \
        php7.2-mysql \
        php7.2-sqlite \
        php7.2-xml \
        php7.2-zip \
        php7.2-mbstring \
        php7.2-gettext \
        php7.2-xdebug \
        php7.2-redis \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -r ppa:git-core/ppa
RUN add-apt-repository -r ppa:ondrej/php

#安装composer
ADD composer.phar /usr/local/bin/composer

RUN chmod 755 /usr/local/bin/composer

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf    /etc/supervisor/supervisord.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

EXPOSE 80 443 22

WORKDIR /opt/htdocs

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf