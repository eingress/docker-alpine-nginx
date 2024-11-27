# builder

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION:-3.20} AS builder

ARG NGINX_VERSION

RUN apk add --no-cache --update \
	build-base \
	pcre-dev \
	wget \
	zlib-dev \
	zlib-static

RUN mkdir -p /build && \
	cd /build && \
	wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxvf nginx-${NGINX_VERSION}.tar.gz

WORKDIR /build/nginx-${NGINX_VERSION}

RUN	./configure \
	--error-log-path=/dev/stderr \
	--http-log-path=/dev/stdout \
	--with-cc-opt="-O2" \
	--with-ld-opt="-s -static" \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& strip /usr/local/nginx/sbin/nginx


RUN addgroup -S nginx && adduser -S -G nginx nginx
RUN chown -R nginx /usr/local/nginx/html

# release

FROM scratch

LABEL maintainer="Scott Mathieson <scott@eingress.io>"

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /etc/passwd /etc/group /etc/

COPY nginx.conf /usr/local/nginx/conf/

STOPSIGNAL SIGQUIT

EXPOSE 80

ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]

CMD ["-g", "daemon off;"]