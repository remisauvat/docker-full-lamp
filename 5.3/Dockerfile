FROM        debian:squeeze
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

ARG         DEBIAN_FRONTEND=noninteractive

# Because the official image does not have the right repos
# From https://wiki.debian.org/fr/DebianSqueeze
RUN         echo "deb http://archive.debian.org/debian squeeze main" > /etc/apt/sources.list
RUN         echo "deb http://archive.debian.org/debian squeeze-lts main" >> /etc/apt/sources.list
RUN         echo "Acquire::Check-Valid-Until false;" >> /etc/apt/apt.conf

# DotDeb configuration and upgrade the system
RUN         apt-get update && \
            apt-get install --force-yes -y --no-install-recommends ca-certificates curl && \
            # Set the correct repo for PHP
            echo "deb http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
            curl -sS http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
            # Clean
            apt-get purge ca-certificates curl -y && \
            apt-get autoremove -y && \
            apt-get clean && \
            rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/*


# Install LAMP Stack
RUN         apt-get update && \
            # Install all packages below :
            apt-get install --force-yes -y --no-install-recommends \

            git supervisor wget \

        	apache2 \

        	mysql-server \

            libapache2-mod-php5 php5-apc php5-cli php5-curl php5-ffmpeg php5-fpm php5-gd php5-geoip php5-imagick php5-imap \
            php5-intl php5-json php5-ldap php5-mcrypt php5-memcached php5-mysql php5-odbc php5-pgsql \
            php5-sqlite php5-ssh2 php5-xdebug php5-xsl && \

            apt-get autoremove -y && \            
            apt-get clean && \
            rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/*


# Prepare PHP
COPY        php-cli.ini    /etc/php5/cli/conf.d/30-custom-php.ini
COPY        php-apache.ini /etc/php5/apache2/conf.d/30-custom-php.ini
RUN         mkdir -p /var/log/php
RUN         chown -R www-data:www-data /var/log/php
RUN         php -r "copy('https://getcomposer.org/download/1.5.1/composer.phar', '/usr/local/bin/composer');" && \
            php -r "if (hash_file('SHA384', '/usr/local/bin/composer') === 'fd3800adeff12dde28e9238d2bb82ba6f887bc6d718eee3e3a5d4f70685a236b9e96afd01aeb0dbab8ae6211caeb1cbe') {echo 'Composer installed';} else {echo 'Hash invalid for downloaded composer.phar'; exit(1);}" && \
            chmod 0755 /usr/local/bin/composer && \
            /usr/local/bin/composer selfupdate --stable
RUN         rm -f /etc/php5/conf.d/xhprof.ini

# Prepare Apache
RUN         mkdir -p /var/www/html
RUN         mv /var/www/index.html /var/www/html/
RUN         sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/sites-available/default*
RUN         sed -i "s/\/var\/www/\/var\/www\/html/g" /etc/apache2/sites-available/default*
RUN         a2enmod rewrite

EXPOSE      80


# Command
COPY        run.sh     /run.sh
RUN         chmod +x    /run.sh

ENV         ENVIRONMENT dev

VOLUME      /var/lib/mysql

# Prepare supervisor
RUN         mkdir -p /var/log/supervisor
COPY        supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Last step for services
CMD         ["/run.sh"]
