#!/bin/bash

sed -i 's/bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf;

if ! ps -ef | grep -v "grep" | grep "/usr/sbin/mysqld"; then
	service mysql start;

	#setting password as mysqladmin = insecure, so we use mysql
	mysql -uroot -p$DB_ROOT_PASSWORD -e \
		"ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';";
	mysql -uroot -p$DB_ROOT_PASSWORD -e \
		"CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;";
	mysql -uroot -p$DB_ROOT_PASSWORD -e \
		"CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';";
	mysql -uroot -p$DB_ROOT_PASSWORD -e \
		"GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';";
	mysql -uroot -p$DB_ROOT_PASSWORD -e \
		"FLUSH PRIVILEGES;";

	echo "Database health :";
	mysqladmin -uroot -p$DB_ROOT_PASSWORD ping;

	echo "Wordpress database was created : ";
	mysqlshow -uroot -p$DB_ROOT_PASSWORD;

	mysqladmin -uroot -p$DB_ROOT_PASSWORD shutdown;
	echo "Database created and configured.";
fi

# need to exec parameters from CMD as PID 1 to avoid zombie processes
exec "$@"
