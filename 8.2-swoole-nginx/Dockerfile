FROM topthink/php:8.2-swoole

#安装nginx
RUN apt update && apt install -y --no-install-recommends gnupg2 ca-certificates lsb-release ubuntu-keyring
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN apt update && apt install -y --no-install-recommends nginx

RUN apt clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm /etc/apt/sources.list.d/nginx.list

#配置nginx
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

ADD supervisord.conf /etc/supervisor/conf.d/nginx.conf
