FROM topthink/php:8.0-swoole

#安装nginx
RUN echo "deb http://nginx.org/packages/ubuntu focal nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt update && apt install -y --no-install-recommends nginx

RUN apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

#配置nginx
ADD nginx.conf /etc/nginx/conf.d/default.conf
ADD supervisord.conf /etc/supervisor/conf.d/nginx.conf
