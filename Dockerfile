# syntax=docker/dockerfile:1
FROM ubuntu:latest as base

# Set the non interactive
ARG DEBIAN_FRONTEND=noninteractive

# Installation dependencies
RUN sed -i -E "s/(archive|security).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    apt-transport-https ca-certificates \
    neovim git wget curl openssh-server tzdata \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apt 

# Set default timezone
ARG TZ="Asia/Shanghai"
RUN rm -f /etc/localtime \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# Add nonroot user with privilege
ARG ROOT_PWD="root" 
ARG ROOT_HOME="/root"
RUN echo "root:${ROOT_PWD}" | chpasswd \
    && mkdir -p ${ROOT_HOME}/shared \
    && mkdir -p /var/run/sshd \
    && sed -i -E "s/^#?PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config 

# Change workDir
WORKDIR ${ROOT_HOME}

# Specify the port listens and its protocol
EXPOSE 22

# Configure entrypoint script
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh 
ENTRYPOINT [ "/docker-entrypoint.sh"]

# Provide defaults for an executing container
CMD ["/bin/bash"]
# CMD ["/usr/sbin/sshd", "-D"]

FROM base as golang
# Install golang
ARG GO_VERSION="1.17.13"
RUN wget -P "/tmp" "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" \
    && rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" 
# && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" 
ENV PATH=“$PATH:/usr/local/go/bin \
    GO111MODULE="on" \
    GOPROXY="https://goproxy.cn,direct"
