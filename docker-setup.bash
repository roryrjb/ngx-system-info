#!/usr/bin/env bash

set -euo pipefail

versions=(1.6.3 1.8.1 1.10.3 1.12.2 1.14.0)

for version in "${versions[@]}"
do
    curl \
        -L "https://nginx.org/download/nginx-$version.tar.gz" \
        -o "/tmp/nginx_$version.tar.gz"

    cd /tmp
    mkdir "nginx_$version"
    tar -xz < "nginx_$version.tar.gz"

    cd "nginx-$version"
    ls

    ./configure \
        --prefix="/root/nginx_$version" \
        --add-module=/tmp/ngx-system-info

    make
    make install
done
