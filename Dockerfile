FROM alpine:3.19

RUN apk add --no-cache bash curl

# 安装 Xray
RUN mkdir -p /etc/xray /usr/local/bin \
    && curl -L -o /usr/local/bin/xray https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64 \
    && chmod +x /usr/local/bin/xray

# 安装 cloudflared
RUN mkdir -p /etc/cloudflared \
    && curl -L -o /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared

# 拷贝 Xray 配置模板
COPY config.json /etc/xray/config.json

# 入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 默认环境变量
ENV UUID=11111111-2222-3333-4444-555555555555
ENV WSPATH=/ws
ENV XRAY_PORT=80
# CLOUD_FLARE_TOKEN 由 Docker 环境变量或 Docker Secret 注入

EXPOSE ${XRAY_PORT}

ENTRYPOINT ["/entrypoint.sh"]
