FROM        ubuntu:14.04
MAINTAINER  Marco Monteiro <marco@neniu.org>

ENTRYPOINT  ["bootstrap.sh"]
EXPOSE      80

ENV         DEBIAN_FRONTEND noninteractive
RUN         dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl && \
            apt-get update && \
            apt-get install -y php5-cli php5-gd php5-pgsql php5-sqlite php5-mysqlnd php5-curl php5-intl php5-mcrypt php5-ldap php5-gmp php5-apcu php5-imagick php5-fpm smbclient nginx

COPY        bootstrap.sh /usr/bin/
COPY        nginx.conf /etc/nginx/
COPY        php.ini /etc/php5/fpm/
COPY        cron.conf /etc/owncloud-cron.conf
ADD         https://download.owncloud.org/community/owncloud-7.0.4.tar.bz2 /root/owncloud.tar.bz2
RUN         mkdir -p /var/www/owncloud /var/log/cron && \
            tar -C /var/www/ -xvf /root/owncloud.tar.bz2 && \
            rm /root/owncloud.tar.bz2 && \
            chmod +x /usr/bin/bootstrap.sh && \
            crontab /etc/owncloud-cron.conf
