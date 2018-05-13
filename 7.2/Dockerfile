FROM        debian:stretch-slim
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

ARG         DEBIAN_FRONTEND=noninteractive

# Create man directory to avoid java to crash on install
RUN         mkdir -p /usr/share/man/man1

# Install Apache + PHP + MySQL Server + Java + Git
RUN         apt update && \
            # Install a few required packages
            apt install -y --no-install-recommends apt-transport-https gnupg ca-certificates curl && \
            # Setup sury repos
            echo "deb https://packages.sury.org/php/ stretch main" >> /etc/apt/sources.list.d/sury.org.list && \
            curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - && \
            # Update, upgrade
            apt update && \
            apt upgrade -y && \
            # Packages
            apt install -y --no-install-recommends \
                git supervisor \
                # Apache
            	apache2 \
                # MySQL Server
            	mysql-server \
                # PHP
                libapache2-mod-php7.2 php7.2-cli php7.2-curl php7.2-gd php7.2-geoip \
                php7.2-imap php7.2-intl php7.2-json php7.2-ldap php7.2-mysqlnd php7.2-odbc \
                php7.2-sqlite php7.2-ssh2 php7.2-tidy php7.2-xdebug php7.2-xsl && \
                # Clean
                # Remove useless files installed for other PHP Versions
                rm -rf /usr/lib/php/20131226 /usr/lib/php/20151012 /usr/lib/php/20160303 /usr/lib/php/7.1 && \
                rm -rf /etc/php/5.6 /etc/php/7.0 /etc/php/7.1 && \
                # Install composer
                curl https://getcomposer.org/download/1.6.5/composer.phar -s -S -o composer.phar && \
                chmod 0755 composer.phar && \
                ./composer.phar selfupdate --stable && \
                # Remove useless packages / files
                apt purge --autoremove -y curl gnupg && \
                apt autoremove -y && \
                apt autoclean && \
                apt clean && \
                rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /var/cache/* /var/log/*

# Prepare Apache
RUN         sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
RUN         a2enmod rewrite
EXPOSE      80

# Prepare PHP
COPY        php-cli.ini    /etc/php/7.2/cli/conf.d/30-custom-php.ini
COPY        php-apache.ini /etc/php/7.2/apache2/conf.d/30-custom-php.ini
RUN         mkdir -p /var/log/apache2 /var/log/php
RUN         chown -R www-data:www-data /var/log/apache2 /var/log/php

COPY        run.sh     /run.sh
RUN         chmod +x   /run.sh

ENV         ENVIRONMENT dev

VOLUME      /var/lib/mysql

# Last step for services
# Prepare supervisor
RUN         mkdir -p /var/log/supervisor
COPY        supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD         ["/run.sh"]
