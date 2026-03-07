#!/bin/sh

if [ ! -f /data/filebrowser.db ]; then
    # First run: initialise database with correct settings
    filebrowser config init \
        -d /data/filebrowser.db \
        --baseURL /upload \
        -r /srv \
        --port 8080 \
        --address 127.0.0.1
else
    # Subsequent runs: force baseURL to stay correct even if volume is old
    filebrowser config set \
        -d /data/filebrowser.db \
        --baseURL /upload
fi

# Add admin user — silently succeeds if already exists
filebrowser users add admin ChangeMe12345 \
    -d /data/filebrowser.db \
    --perm.admin 2>/dev/null || true

# Ensure nginx (runs as 'nginx' user) can read everything in /srv
# and that filebrowser creates world-readable dirs/files going forward
chmod -R a+rX /srv 2>/dev/null || true
umask 022

filebrowser \
    -d /data/filebrowser.db \
    -r /srv \
    --baseURL /upload \
    --port 8080 \
    --address 127.0.0.1 &

exec nginx -g "daemon off;"
