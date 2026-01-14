# 基于 Ubuntu 24.04
FROM ubuntu:24.04

ENV HOSTNAME=sandbox

# 设置非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更换为阿里云镜像源（兼容 DEB822 `.sources` 文件）
RUN sed -i 's|archive.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true && \
    sed -i 's|security.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true

# 更新包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ffmpeg \
    pandoc \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Chinese fonts and language support
RUN apt-get update && apt-get install -y \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    language-pack-zh-hans \
    locales \
    && locale-gen zh_CN.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10.12
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure pip to use Aliyun mirror system-wide and via env (safe if /home is mounted)
RUN printf '[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple/' > /etc/pip.conf
ENV PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/

# Install Node.js 20.18.0
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# 为 ubuntu 用户添加 sudo 权限
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /workspace && chown ubuntu:ubuntu /workspace

# 切换到 ubuntu 用户
USER ubuntu

# Configure npm for the ubuntu user only:
# - set registry to Aliyun (written to ~/.npmrc)
# - set a user-local prefix so `npm install -g` installs into the user's home
RUN npm config set registry https://registry.npmmirror.com && \
    npm config set prefix /home/ubuntu/.npm-global && \
    mkdir -p /home/ubuntu/.npm-global && \
    npm install -g pptxgenjs playwright sharp docx && \
    npx playwright install chromium --with-deps

# Ensure user's npm global bin is on PATH
ENV PATH=/home/ubuntu/.npm-global/bin:$PATH
ENV NODE_PATH=/home/ubuntu/.npm-global/lib/node_modules
# 设置工作目录
WORKDIR /workspace

# 设置默认命令
ENTRYPOINT ["sleep" "infinity"]