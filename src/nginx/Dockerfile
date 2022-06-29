FROM nginx:1.21.6

COPY default.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

RUN addgroup --gid 1000 app
RUN adduser --uid 1000 --gid 1000 --home /var/www --shell /bin/bash --system app

RUN unlink /var/log/nginx/access.log
RUN unlink /var/log/nginx/error.log
RUN touch /var/log/nginx/access.log
RUN touch /var/log/nginx/error.log
RUN chmod 777 /var/log/nginx/access.log
RUN chmod 777 /var/log/nginx/error.log

