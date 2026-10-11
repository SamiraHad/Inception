#!/bin/bash

cd /var/www/html

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

for i in $(seq 1 30); do
	if mariadb -h mariadb -P 3306 -u "${MYSQL_USER}" -p"${DB_PASSWORD}" \
		-e "SELECT 1;" >/dev/null 2>&1; then
		break
	fi

	sleep 1
done

if ! mariadb -h mariadb -P 3306  -u "${MYSQL_USER}" -p"${DB_PASSWORD}" \
	-e "SELECT 1;" >/dev/null 2>&1; then
	echo "MariaDB is unavailable."
	exit 1
fi

if [ ! -f wp-config.php ]; then
	if [ ! -f index.php ]; then
		wp core download --allow-root
	fi

	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${DB_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--allow-root
fi

if ! wp core is-installed --url="https://${DOMAIN_NAME}" --allow-root; then

	export HTTP_HOST="${DOMAIN_NAME}"
	export REQUEST_URI="/"
	export SCRIPT_NAME="/index.php"
	export SCRIPT_FILENAME="/var/www/html/index.php"
	export PHP_SELF="/index.php"

	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--allow-root

	wp user create \
		"${WP_USER}" \
		"${WP_USER_EMAIL}" \
		--user_pass="${WP_USER_PASSWORD}" \
		--role=author \
		--allow-root
fi

exec php-fpm8.2 -F
