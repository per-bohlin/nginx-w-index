FROM nginx:latest
WORKDIR /root
RUN apt-get update && apt-get install -y curl
RUN curl 'https://hg.nginx.org/pkg-oss/raw-file/tip/build_module.sh' > build_module.sh && chmod +x build_module.sh
RUN echo "#!/bin/sh\n"'exec "$@"' > /usr/local/bin/sudo && chmod +x /usr/local/bin/sudo
RUN /bin/bash -c "./build_module.sh -n fancyindex -y -v \${NGINX_VERSION//-*} -o /root/ https://github.com/aperezdc/ngx-fancyindex.git"
RUN dpkg -i /root/*.deb

FROM nginx:latest
COPY --from=0 /etc/nginx/modules/ngx_http_fancyindex_module.so /etc/nginx/modules/ngx_http_fancyindex_module.so
COPY files/10_fancyindex.conf /etc/nginx/modules/10_fancyindex.conf
RUN sed -ri '/index  index\.html/a         fancyindex on;\n        fancyindex_exact_size off;\n' /etc/nginx/conf.d/default.conf
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

# FROM nginx:1.27.0-alpine
# LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

# ARG PKG_VERSION=1.24.0-r16

# RUN apk add --no-cache\
#         nginx \
#         nginx-mod-http-headers-more\
#         nginx-mod-http-fancyindex
#        nginx-mod-http-brotli=${PKG_VERSION}

# RUN apk add --no-cache \
#     nginx-mod-http-headers-more=${NGINX_VERSION} \
#     nginx-mod-http-fancyindex=${NGINX_VERSION} \
#     nginx-mod-http-brotli=${NGINX_VERSION}

# RUN sed -i '1s#^#include /etc/nginx/modules/*.conf;#' /etc/nginx/nginx.conf

# EXPOSE 80 443
# STOPSIGNAL SIGTERM

# ENTRYPOINT ["/entrypoint.sh"]
