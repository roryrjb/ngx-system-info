#!/usr/bin/env bash

set -euo pipefail

versions=(1.6.3 1.8.1 1.10.3 1.12.2 1.14.0)

for version in "${versions[@]}"
do
    "/root/nginx_$version/sbin/nginx" -p /root -c /root/nginx.conf
    sleep 1
    curl -v http://localhost:8000/system_info
    kill -2 "$(cat /root/nginx.pid)"
done
