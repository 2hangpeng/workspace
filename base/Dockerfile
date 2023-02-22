# syntax=docker/dockerfile:1
FROM ubuntu:22.04 as base

# Set the non interactive
ARG DEBIAN_FRONTEND=noninteractive

# Installation dependencies
RUN sed -i -E "s/(archive|security).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    software-properties-common tzdata \
    && apt-add-repository ppa:fish-shell/release-3 \
    && apt install -y fish \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/cache/apt \
    && rm -rf /var/tmp/*

# Set default timezone
ARG TZ="Asia/Shanghai"
RUN rm -f /etc/localtime \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# Configure entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh 
ENTRYPOINT [ "/docker-entrypoint.sh"]

# Provide defaults for an executing container
CMD ["/bin/fish"]
