#!/bin/sh

filebrowser \
  --database /data/filebrowser.db \
  --root /srv \
  --baseurl /files \
  --port 8080 \
  --address 127.0.0.1 &

exec nginx -g "daemon off;"
