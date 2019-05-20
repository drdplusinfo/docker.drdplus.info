#!/usr/bin/env bash

nohup php-fpm &

cd /var/www/blog/ && nohup sudo -u www-data sh -c node_modules/.bin/gulp &

/usr/local/bin/caddy -conf /etc/caddy/Caddyfile