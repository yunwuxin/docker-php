FROM topthink/php:8.0-swoole

#安装nginx
RUN apt-get update && \
    apt-get -y install --no-install-recommends wget gnupg ca-certificates && \
    wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - && \
    echo "deb http://openresty.org/package/ubuntu focal main" \
        | tee /etc/apt/sources.list.d/openresty.list && \
    apt-get update && apt-get -y install openresty && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

#配置nginx
ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD web.conf /etc/nginx/conf.d/default.conf
ADD supervisord.conf /etc/supervisor/conf.d/nginx.conf
