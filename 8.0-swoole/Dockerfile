FROM phpdockerio/php80-cli

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential php8.0-dev php8.0-redis supervisor libcurl4-openssl-dev zlib1g-dev libssl-dev && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/build && \
    cd ~/build && \
    rm -rf ./swoole-src

COPY swoole-src-4.6.1.tar.gz ./tmp/swoole.tar.gz

RUN tar zxvf ./tmp/swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure \
    --enable-openssl \
    --enable-swoole-curl \
    --enable-swoole-json \
    --enable-http2 && \
    make && make install && \
    rm -rf ~/build
RUN echo "extension=swoole.so" > /etc/php/8.0/mods-available/swoole.ini
RUN phpenmod swoole

RUN sed -i '/disable_functions =/cdisable_functions = curl_multi_exec' /etc/php/8.0/cli/php.ini

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN usermod -s /bin/bash www-data

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
