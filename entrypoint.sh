#!/bin/sh

if [ ! -f /data/filebrowser.db ]; then
    # First run: initialise database with correct settings
    filebrowser config init \
        -d /data/filebrowser.db \
        --baseurl /files \
        -r /srv \
        --port 8080 \
        --address 127.0.0.1
else
    # Subsequent runs: force baseURL to stay correct even if volume is old
    filebrowser config set \
        -d /data/filebrowser.db \
        --baseurl /files
fi

filebrowser \
    -d /data/filebrowser.db \
    -r /srv \
    --baseurl /files \
    --port 8080 \
    --address 127.0.0.1 &

exec nginx -g "daemon off;"
