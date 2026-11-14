FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates && \
    mkdir -p /etc/xray && \
    curl -L -o /tmp/xray.zip https://github.com && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/*

RUN cat << 'EOF' > /etc/xray/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 10000,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "a859511f-879a-46a4-aafd-fce6fb55546d"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vless"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

EXPOSE 10000

CMD ["/usr/local/bin/xray", "run", "-c", "/etc/xray/config.json"]