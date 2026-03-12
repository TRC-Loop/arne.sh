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

# Full nginx.conf — owns the entire config so log_format/limit_req_zone
# are in the http{} context where they belong (conf.d snippets can't do that)
COPY nginx.conf /etc/nginx/nginx.conf

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
