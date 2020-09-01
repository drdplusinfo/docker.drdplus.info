#!/usr/bin/env bash

set -x

nohup php-fpm &

/usr/bin/caddy run --config /etc/caddy/Caddyfile --watch