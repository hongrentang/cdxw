#!/bin/bash
set -e

# 替换 Xray 配置中的 UUID / WSPATH / PORT
sed -i "s/REPLACE_UUID/$UUID/g" /etc/xray/config.json
sed -i "s#REPLACE_WSPATH#$WSPATH#g" /etc/xray/config.json
sed -i "s/REPLACE_PORT/$XRAY_PORT/g" /etc/xray/config.json

echo "启动 Xray..."
xray -c /etc/xray/config.json &

sleep 3

# 从环境变量安全获取 Token
if [ -z "$CLOUD_FLARE_TOKEN" ]; then
    echo "ERROR: CLOUD_FLARE_TOKEN is not set!"
    exit 1
fi

echo "启动 Cloudflare 固定隧道..."
cloudflared service install "$CLOUD_FLARE_TOKEN"

exec cloudflared tunnel run
