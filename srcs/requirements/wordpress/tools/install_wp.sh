#!/bin/bash

if [ ! -f /usr/local/bin/wp ]; then
	mkdir -p /run/php/;
	touch /run/php/php7.3-fpm.pid;
	chown -R www-data:www-data /var/www/*;
	chown -R 755 /var/www/*;
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	php wp-cli.phar --info;
	chmod 755 wp-cli.phar;
	mv wp-cli.phar /usr/local/bin/wp;
	wp cli update;


	# configuration par default wp-cli : bash completion for the `wp` command
	_wp_complete() {
		local OLD_IFS="$IFS"
		local cur=${COMP_WORDS[COMP_CWORD]}

		IFS=$'\n';  # want to preserve spaces at the end
		local opts="$(wp cli completions --line="$COMP_LINE" --point="$COMP_POINT")"

		if [[ "$opts" =~ \<file\>\s* ]]
		then
			COMPREPLY=( $(compgen -f -- $cur) )
		elif [[ $opts = "" ]]
		then
			COMPREPLY=( $(compgen -f -- $cur) )
		else
			COMPREPLY=( ${opts[*]} )
		fi

		IFS="$OLD_IFS"
		return 0
	}
	complete -o nospace -F _wp_complete wp

fi


cd /var/www/html;


if [ ! -f wp-config.php ]; then

	wp core download \
		--allow-root;

	wp config create \
		--allow-root \
		--dbname=${DB_NAME} \
		--dbuser=${DB_USER} \
		--dbpass=${DB_PASSWORD} \
		--dbhost=${DB_HOST} \
		--dbprefix=wp_ \
		--dbcharset=utf8;

fi

if [ ! "$(wp core is-installed --allow-root)" ]; then

	wp core install \
		--allow-root \
		--url=${WEBSITE_URL} \
		--title=${DB_NAME} \
		--admin_user=${WEBSITE_MAIN_LOGIN} \
		--admin_password=${WEBSITE_MAIN_PASSWORD} \
		--admin_email=${WEBSITE_MAIN_EMAIL};


	wp core update \
		--allow-root;


	wp user create \
		--allow-root \
		${DB_USER} \
		${WEBSITE_USER_EMAIL} \
		--user_pass=${DB_PASSWORD} \
		--role=editor;


	wp theme install riverbank \
		--allow-root \
		--activate;

fi

exec "$@"
