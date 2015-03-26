FROM nginx:latest

RUN sed -i -e 's/^worker_processes  1;$/worker_processes 4;/' /etc/nginx/nginx.conf && \
    rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/conf.d/example_ssl.conf

ADD conf/extraconfig.conf /etc/nginx/conf.d/00-extraconfig.conf
ADD conf/site.conf /etc/nginx/conf.d/50-site.conf
