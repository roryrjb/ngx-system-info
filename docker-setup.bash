#!/usr/bin/env bash

set -e
set -o pipefail

versions=(1.6.3 1.8.1 1.10.3 1.12.2 1.14.0)

for version in "${versions[@]}"
do
    curl \
        -L https://nginx.org/download/nginx-$version.tar.gz \
        -o /tmp/nginx_$version.tar.gz

    cd /tmp
    mkdir nginx_$version
    cat nginx_$version.tar.gz | gunzip | tar -x

    cd nginx-$version
    ls

    ./configure \
        --prefix=/root/nginx_$version \
        --add-module=/tmp/ngx-system-info

    make
    make install
done