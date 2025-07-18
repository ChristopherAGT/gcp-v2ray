#!/bin/bash

# Usa valores por defecto si no están definidos
DHOST=${DHOST:-"127.0.0.1"}
DPORT=${DPORT:-"1080"}
PORT=${PORT:-"8080"}  # Puerto que Cloud Run inyecta

# Genera el config.json dinámicamente
cat > /etc/v2ray/config.json <<EOF
{
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "d805e3c5-92f3-4e4b-aeb7-d705bd789f4e",
            "level": 0,
            "email": "user@example.com"
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
      "protocol": "freedom",
      "settings": {
        "redirect": "$DHOST:$DPORT"
      }
    }
  ]
}
EOF

# Ejecuta v2ray
exec v2ray run -config /etc/v2ray/config.json
