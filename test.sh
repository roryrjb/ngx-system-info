#!/bin/sh

set -e

version=1.14.0
nginx_root="/usr/local/nginx"

curl \
    -L "https://nginx.org/download/nginx-$version.tar.gz" \
    -o "/tmp/nginx_$version.tar.gz"

cd /tmp
mkdir "nginx_$version"
tar -xzf "nginx_$version.tar.gz"

cd "nginx-$version"

# static

./configure \
    --add-module=/tmp/ngx-system-info

make
make install

# run nginx

"$nginx_root/sbin/nginx" -p /root -c /root/nginx.conf
sleep 1
curl -v http://localhost:8000/system_info
kill -2 "$(cat /root/nginx.pid)"

# dynamic

make clean
./configure --with-compat
make
make install

./configure \
    --with-compat \
    --add-dynamic-module=/tmp/ngx-system-info

make modules

mkdir -p $nginx_root/modules
cp objs/ngx_http_system_info_module.so \
    $nginx_root/modules/

"$nginx_root/sbin/nginx" -p /root -c /root/nginx.dynamic.conf
sleep 1
curl -v http://localhost:8000/system_info
kill -2 "$(cat /root/nginx.pid)"
