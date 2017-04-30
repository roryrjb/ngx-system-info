# ngx-system-info

> Nginx module for displaying `sysinfo` as JSON (Linux only).

### Installation

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
which will be output as JSON `application/json`:

```nginx
location /system_info {
  system_info;
}
```