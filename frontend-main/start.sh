#!/bin/sh

echo "Starting frontend-main with ACTIVE_COLOR=$ACTIVE_COLOR"

if [ "$ACTIVE_COLOR" = "green" ]; then
  PROXY_TARGET="frontend-green:3000"
else
  PROXY_TARGET="frontend-blue:3000"
fi

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
  listen 80;

  location / {
    proxy_pass http://$PROXY_TARGET;
    proxy_http_version 1.1;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    client_max_body_size 10M;
    proxy_buffering off;
  }
}
EOF

nginx -g 'daemon off;'