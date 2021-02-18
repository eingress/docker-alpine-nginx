# Docker Alpine Nginx

Alpine based Nginx with all default modules.

Run using the bundled lightweight nginx.conf…

```shell
docker run -d -p 8080:80 -v /path/to/html:/usr/local/nginx/html eingressio/alpine-nginx
```

…or using a custom nginx.conf

```sh
docker run -d -p 8080:80 -v /path/to/html:/usr/local/nginx/html -v /path/to/nginx.conf:/usr/local/nginx/conf/nginx.conf eingressio/alpine-nginx
```
