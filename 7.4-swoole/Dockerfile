FROM phpdockerio/php74-cli

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential php-pear php7.4-dev php7.4-redis php7.4-mysql supervisor libcurl4-openssl-dev zlib1g-dev libssl-dev && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN pecl install swoole-4.6.1 \
    --enable-openssl \
    --enable-swoole-curl \
    --enable-swoole-json \
    --enable-http2 && \
    echo "extension=swoole.so" > /etc/php/7.4/mods-available/swoole.ini && \
    phpenmod swoole && \
    rm -rf /tmp/*

RUN sed -i '/disable_functions =/cdisable_functions = curl_multi_exec' /etc/php/7.4/cli/php.ini

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN usermod -s /bin/bash www-data

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf

WORKDIR /opt/htdocs
