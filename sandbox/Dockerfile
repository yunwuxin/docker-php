# 基于 Ubuntu 24.04
FROM ubuntu:24.04

# 设置环境变量支持 UTF-8 编码
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 设置非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更换为阿里云镜像源
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list && \
    sed -i "s/security.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

# 更新包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    pandoc \
    sudo \
    && apt-get remove -y nodejs npm libnode-dev 2>/dev/null || true \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 使用阿里云 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

# 设置 pip 国内镜像（系统级），使用阿里云镜像
ENV PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple
RUN printf '[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple\n' > /etc/pip.conf

# 为 ubuntu 用户添加 sudo 权限
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 设置工作目录
WORKDIR /home/ubuntu

# 切换到 ubuntu 用户
USER ubuntu

# 设置默认命令
ENTRYPOINT ["sleep" "infinity"]