# 基于 Ubuntu 24.04
FROM ubuntu:24.04

ENV HOSTNAME=sandbox

# 设置非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    zip \
    unzip \
    gnupg \
    ffmpeg \
    pandoc \
    sudo \
    xvfb \
    x11vnc \
    netcat-openbsd \
    file \
    git \
    git-lfs \
    s3fs

# 允许 FUSE 挂载对其他用户可见
RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

# Install Chinese fonts and language support
RUN apt-get update && apt-get install -y \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    language-pack-zh-hans \
    locales \
    && locale-gen zh_CN.UTF-8

# Install Python 3 on Ubuntu using the distro packages. The system Python is
# externally managed, so we avoid direct pip installs into it and instead use
# a dedicated virtual environment for project dependencies.
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv

# Install Node.js 20.18.0
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs

# 为 ubuntu 用户添加 sudo 权限
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /workspace && chown ubuntu:ubuntu /workspace

# 切换到 ubuntu 用户
USER ubuntu

# =========================
# Node.js environment
# =========================

# Configure a user-local prefix so `npm install -g` installs into the user's home.
ENV NPM_CONFIG_PREFIX=/home/ubuntu/.npm-global
RUN mkdir -p /home/ubuntu/.npm-global

# Ensure user's npm global bin is on PATH.
ENV PATH=/home/ubuntu/.npm-global/bin:$PATH
ENV NODE_PATH=/home/ubuntu/.npm-global/lib/node_modules

# Install Playwright CLI and browsers globally for the ubuntu user.
RUN npm install -g playwright@1.63.0-alpha-2026-08-31 @playwright/cli@0.1.19 && \
    playwright-cli install-browser chromium --with-deps
RUN mkdir -p /home/ubuntu/.playwright && \
    echo '{"browser":{"browserName":"chromium","launchOptions":{"channel":"chromium","args":["--window-position=0,0"]},"contextOptions":{"viewport":{"width":1920,"height":1080}}},"allowUnrestrictedFileAccess":true}' > /home/ubuntu/.playwright/cli.config.json

RUN npm install -g @topthink/ai@1.0.3 && \
    npm cache clean --force

# =========================
# Python environment
# =========================

# Create a dedicated Python virtual environment for the ubuntu user.
ENV VIRTUAL_ENV=/home/ubuntu/.venv
RUN python3 -m venv "$VIRTUAL_ENV"

# Ensure the venv's bin directory is on PATH before the system Python.
ENV PATH=/home/ubuntu/.venv/bin:$PATH

# Install Python packages into the project venv so the default `python` command
# resolves to the virtual environment instead of the system interpreter.
RUN python -m pip install --no-cache-dir matplotlib pandas playwright==1.63.0

# Configure matplotlib for Chinese fonts
RUN mkdir -p /home/ubuntu/.config/matplotlib && \
    echo "font.sans-serif: Noto Sans CJK JP, DejaVu Sans, sans-serif" > /home/ubuntu/.config/matplotlib/matplotlibrc && \
    echo "axes.unicode_minus: False" >> /home/ubuntu/.config/matplotlib/matplotlibrc && \
    echo "font.family: sans-serif" >> /home/ubuntu/.config/matplotlib/matplotlibrc

RUN sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Configure Chinese mirrors for container runtime only. Build dependencies above use official sources.
USER root
RUN sed -i 's|archive.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true && \
    sed -i 's|security.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true && \
    printf '[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple/\n' > /etc/pip.conf
ENV PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
USER ubuntu

# 设置工作目录
WORKDIR /workspace

# 设置默认命令
ENTRYPOINT ["sleep","infinity"]
