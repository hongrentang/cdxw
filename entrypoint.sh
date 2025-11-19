#!/bin/bash

# 替换 Xray 参数
sed -i "s/REPLACE_UUID/$UUID/g" /etc/xray/config.json
sed -i "s#REPLACE_WSPATH#$WSPATH#g" /etc/xray/config.json

echo "启动 Xray..."
xray -c /etc/xray/config.json &

sleep 3

echo "使用固定隧道 Token 启动 Cloudflare Tunnel..."
TOKEN=$(cat /etc/cloudflared/token.txt)
cloudflared service install "$TOKEN"

exec cloudflared tunnel run
