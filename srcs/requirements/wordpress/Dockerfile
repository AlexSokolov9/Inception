FROM debian:buster

RUN apt-get update \
	&& apt-get install -y \
		php7.3 \
		php7.3-mysql \
		php7.3-fpm \
		php7.3-mbstring \
		curl \
		php7.3-curl \
		php7.3-gd \
		php7.3-zip \
		php7.3-xml \
		default-mysql-client \
	&& rm -rf /var/lib/apt/lists/*

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
COPY ./tools /var/www/

RUN chmod 755 /var/www/install_wp.sh

WORKDIR /var/www/

ENTRYPOINT ["/var/www/install_wp.sh"]

EXPOSE 9000

CMD ["php-fpm7.3", "--nodaemonize"]
