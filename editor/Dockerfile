# syntax=docker/dockerfile:1
FROM zhangpeng0304/workspace-base:latest as editor
# Install golang
ARG GO_VERSION="1.17.13"
RUN wget -P "/tmp" "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" \
    && rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" 
# && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" 
ENV PATH=“$PATH:/usr/local/go/bin \
    GO111MODULE="on" \
    GOPROXY="https://goproxy.cn,direct"
