FROM phpdockerio/php:8.2-cli

ENV TZ=Asia/Shanghai

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    vim build-essential php-pear php8.2-dev php8.2-redis php8.2-mysql php8.2-gd php8.2-sqlite3 php8.2-bcmath php8.2-intl supervisor libcurl4-openssl-dev zlib1g-dev libssl-dev && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net

RUN printf "no\nyes\nyes\nno\nyes\nyes\n" | pecl install swoole-4.8.13 && \
    echo "extension=swoole.so" > /etc/php/8.2/mods-available/swoole.ini && \
    phpenmod swoole && \
    rm -rf /tmp/*

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir /var/www
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN usermod -s /bin/bash www-data
RUN chown -R www-data:www-data /var/www

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf

WORKDIR /opt/htdocs
