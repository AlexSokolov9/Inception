FROM debian:buster

RUN apt-get update \
	&& apt-get install -y mariadb-server procps \
	&& rm -rf /var/lib/apt/lists/* 

COPY ./conf/config_db.sh /

RUN chmod 755 /config_db.sh

ENTRYPOINT ["sh", "/config_db.sh"]

EXPOSE 3306

CMD ["mysqld_safe"]
