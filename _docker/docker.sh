#!/usr/bin/env bash

nohup php-fpm &

/usr/local/bin/caddy -conf /etc/caddy/Caddyfile