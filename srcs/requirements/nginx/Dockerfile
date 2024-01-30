FROM debian:buster

RUN apt-get update && apt-get install -y nginx openssl

COPY ./conf/default_nginx_conf /etc/nginx/sites-enabled/default

RUN chmod 755 /etc/nginx/sites-enabled/default \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:4096 \ 
	-keyout /etc/ssl/private/inception_ssl.key \
	-out /etc/ssl/certs/inception_ssl.crt \
	-subj="/C=FR/L=Paris/O=Student/CN=asokolov.42.fr"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
