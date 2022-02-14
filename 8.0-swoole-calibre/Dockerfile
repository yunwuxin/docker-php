FROM topthink/php:8.0-swoole

RUN \
    echo "deb http://ppa.topthink.com/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/git-core.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt update && apt install -y \
    language-pack-zh-hant language-pack-zh-hans language-pack-zh-hant-base language-pack-zh-hans-base \
    language-pack-gnome-zh-hant language-pack-gnome-zh-hans language-pack-gnome-zh-hant-base language-pack-gnome-zh-hans-base \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    xfonts-wqy \
    ttf-wqy-zenhei \
    wget \
    git \
    git-lfs \
    python \
    calibre

#字体
RUN mkdir -p /usr/share/fonts/winFonts

ADD msyh.ttf /usr/share/fonts/winFonts/msyh.ttf

RUN mkfontscale && mkfontdir && fc-cache -fv

#安装calibre
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin
RUN rm -rf /tmp/*

#安装nodejs
RUN wget -qO- https://deb.nodesource.com/setup_16.x | bash -
RUN apt install nodejs
RUN npm install -g npm@latest

RUN apt install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

#清理
RUN apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

