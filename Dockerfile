FROM nginx:alpine

# Download filebrowser binary
RUN wget -qO- https://github.com/filebrowser/filebrowser/releases/latest/download/linux-amd64-filebrowser.tar.gz \
    | tar -xzf - -C /usr/local/bin filebrowser \
    && chmod +x /usr/local/bin/filebrowser \
    && mkdir -p /srv /data

# Nginx config — proxies /files to filebrowser running on localhost:8080
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Startup script — launches filebrowser then nginx in foreground
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Site files
WORKDIR /usr/share/nginx/html/
COPY . .
# Remove config files that landed here via COPY . .
RUN rm -f nginx.conf entrypoint.sh

# /srv  = uploaded files  (mount a persistent volume here in Coolify)
# /data = filebrowser DB  (mount a persistent volume here in Coolify)
VOLUME ["/srv", "/data"]

EXPOSE 80
CMD ["/entrypoint.sh"]
