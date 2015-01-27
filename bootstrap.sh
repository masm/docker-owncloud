#!/bin/sh

touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
touch /var/log/cron/owncloud.log

chown -R www-data:www-data /var/www/owncloud

tail -F /var/log/nginx/*.log /var/log/cron/owncloud.log &

/usr/sbin/cron -f &
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
