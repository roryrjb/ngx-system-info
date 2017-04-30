# ngx-system-info

> Nginx module for displaying `sysinfo` as JSON (Linux only).

### Installation

Firstly clone this repo somewhere.

__Download Nginx source:__

```
$ wget https://nginx.org/download/nginx-VERSION.tar.gz
$ cat nginx-VERSION.tar.gz | gunzip | tar -x
$ cd nginx-VERSION
```

__Build as static module in Nginx:__

```
$ ./configure --add-module=/path/to/ngx-system-info
$ make
$ sudo make install
```

### Usage

Specify a `location` in your Nginx configuration to display the data,
which will be output as JSON (`application/json`):

```nginx
location /system_info {
  system_info;
}
```

__Example output:__

```json
{
  "uptime": 3618,
  "totalram": 8223174656,
  "freeram": 3047157760,
  "loadavg": [
     1.29,  0.84,  0.81
  ],
  "sharedram": 166408192,
  "bufferram": 102264832,
  "totalswap": 8438935552,
  "freeswap": 8438935552,
  "procs": 857
}
```