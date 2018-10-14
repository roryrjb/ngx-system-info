FROM ubuntu:16.04

RUN apt update && apt update -y
RUN apt install -y build-essential curl libssl-dev libpcre3-dev

RUN mkdir /tmp/ngx-system-info

COPY . /tmp/ngx-system-info
COPY test.sh /tmp/test.sh
COPY nginx.conf /root/nginx.conf
COPY nginx.dynamic.conf /root/nginx.dynamic.conf

RUN mkdir /root/logs
RUN sh /tmp/test.sh
