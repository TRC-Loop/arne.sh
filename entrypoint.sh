#!/bin/sh

filebrowser --config /filebrowser.json &

exec nginx -g "daemon off;"
