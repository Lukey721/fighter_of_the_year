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
  }
}
EOF

nginx -g 'daemon off;'