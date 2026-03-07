#!/bin/sh

if [ ! -f /data/filebrowser.db ]; then
    # First run: initialise database with correct settings
    filebrowser config init \
        -d /data/filebrowser.db \
        --baseURL /stone \
        -r /srv \
        --port 8080 \
        --address 127.0.0.1
else
    # Subsequent runs: force baseURL to stay correct even if volume is old
    filebrowser config set \
        -d /data/filebrowser.db \
        --baseURL /stone
fi

# Create admin user if no users exist yet
USER_COUNT=$(filebrowser users ls -d /data/filebrowser.db 2>/dev/null | grep -c '@' || echo 0)
if [ "$USER_COUNT" -eq 0 ]; then
    filebrowser users add admin ChangeMe12345 \
        -d /data/filebrowser.db \
        --perm.admin
fi

filebrowser \
    -d /data/filebrowser.db \
    -r /srv \
    --baseURL /stone \
    --port 8080 \
    --address 127.0.0.1 &

exec nginx -g "daemon off;"
