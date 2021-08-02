FROM phpdockerio/php74-cli

ENV TZ=Asia/Shanghai

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential php-pear php7.4-dev php7.4-redis php7.4-mysql php7.4-gd php7.4-sqlite3 php7.4-bcmath supervisor libcurl4-openssl-dev zlib1g-dev libssl-dev && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net

RUN printf "no\nyes\nyes\nno\nyes\nyes\n" | pecl install swoole-4.7.0 && \
    echo "extension=swoole.so" > /etc/php/7.4/mods-available/swoole.ini && \
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
