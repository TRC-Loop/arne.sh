FROM alpine:3.21

# Use Alpine's own nginx so nginx-mod-http-fancyindex is version-compatible.
# The official nginx:alpine image is a custom build; its modules can't be
# installed from Alpine's package repos.
RUN apk add --no-cache nginx nginx-mod-http-fancyindex

# Download filebrowser binary
RUN wget -qO- https://github.com/filebrowser/filebrowser/releases/latest/download/linux-amd64-filebrowser.tar.gz \
    | tar -xzf - -C /usr/local/bin filebrowser \
    && chmod +x /usr/local/bin/filebrowser \
    && mkdir -p /srv /data

# Nginx config — proxies /upload to filebrowser, fancyindex for /stone/
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
