FROM phpdockerio/php80-cli

ENV TZ=Asia/Shanghai

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential php-pear php8.0-dev php8.0-redis php8.0-mysql php8.0-gd php8.0-sqlite3 php8.0-bcmath php8.0-intl supervisor libcurl4-openssl-dev zlib1g-dev libssl-dev && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net

RUN printf "no\nyes\nyes\nno\nyes\nyes\n" | pecl install swoole-4.8.6 && \
    echo "extension=swoole.so" > /etc/php/8.0/mods-available/swoole.ini && \
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
