#!/usr/bin/env bash

nohup sh -c php-fpm &

cd /var/www/blog/ && nohup sh -c node_modules/.bin/gulp &

/usr/local/bin/caddy -conf /etc/caddy/Caddyfile