FROM ubuntu:16.04

RUN apt update && apt update -y
RUN apt install -y build-essential curl libssl-dev libpcre3-dev

RUN mkdir /tmp/ngx-system-info

COPY . /tmp/ngx-system-info
COPY docker-setup.bash /tmp/docker-setup.bash

RUN /tmp/docker-setup.bash

COPY docker-test.bash /tmp/docker-test.bash
COPY nginx.conf /root/nginx.conf

RUN mkdir /root/logs

CMD ["/tmp/docker-test.bash"]
