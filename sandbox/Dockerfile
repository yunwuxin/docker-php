# 基于 Ubuntu 22.04
FROM ubuntu:22.04

# 设置非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更换为阿里云镜像源
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list && \
    sed -i "s/security.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

# 更新包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    pandoc \
    sudo \
    && apt-get remove -y nodejs npm libnode-dev 2>/dev/null || true \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 安装 mount-s3 (AWS S3 Mountpoint)
RUN wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.deb && \
    apt-get update && apt-get install -y ./mount-s3.deb && \
    rm -f mount-s3.deb

# 使用阿里云 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

# 创建 ubuntu 用户和组
RUN groupadd -r ubuntu \
    && useradd -r -g ubuntu -d /home/ubuntu -s /bin/bash ubuntu \
    && mkdir -p /home/ubuntu \
    && chown -R ubuntu:ubuntu /home/ubuntu

# 为 ubuntu 用户添加 sudo 权限
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 设置工作目录
WORKDIR /home/ubuntu

# 切换到 ubuntu 用户
USER ubuntu

# 设置默认命令
CMD ["/bin/bash"]