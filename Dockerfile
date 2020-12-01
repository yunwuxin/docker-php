FROM ubuntu:20.04

ADD sources.list    /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        locales

#安装git
RUN add-apt-repository ppa:git-core/ppa

RUN apt-get update && apt-get install -y --no-install-recommends \
        supervisor \
        unzip \
        git \
        ca-certificates \
        curl

RUN locale-gen en_GB.utf8 en_US.utf8 es_ES.utf8 de_DE.UTF-8

#安装nginx
RUN apt install gpg-agent -y
RUN echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt update && apt install -y nginx

ENV \
  LC_ALL=en_GB.UTF-8 \
  LANG=en_GB.UTF-8 \
  LANGUAGE=en_GB.UTF-8

RUN C_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y \
        php7.4 \
        php7.4-dev \
        php7.4-cli \
        php7.4-bcmath \
        php7.4-bz2 \
        php7.4-dba \
        php7.4-imap \
        php7.4-intl \
        php7.4-soap \
        php7.4-tidy \
        php7.4-curl \
        php7.4-gd \
        php7.4-mysql \
        php7.4-xml \
        php7.4-zip \
        php7.4-mbstring \
        php7.4-gettext \
        php7.4-redis \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -r ppa:git-core/ppa
RUN add-apt-repository -r ppa:ondrej/php

RUN mkdir -p ~/build && \
    cd ~/build && \
    rm -rf ./swoole-src

COPY swoole-src-4.5.9.tar.gz ./tmp/swoole.tar.gz

RUN tar zxvf ./tmp/swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure \
    --enable-openssl \
    --enable-http2 && \
    make && sudo make install
RUN echo "extension=swoole.so" > /etc/php/7.4/mods-available/swoole.ini
RUN phpenmod swoole

#配置nginx
ADD nginx.conf /etc/nginx/conf.d/default.conf

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf    /etc/supervisor/supervisord.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN usermod -s /bin/bash www-data

#安装composer
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer clear-cache

WORKDIR /opt/htdocs

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
