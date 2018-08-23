FROM        debian:stretch-slim
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

ARG         DEBIAN_FRONTEND=noninteractive

# Create man directory to avoid java to crash on install
RUN         mkdir -p /usr/share/man/man1

# Install Apache + PHP + MySQL Server + Java + Git
RUN         apt update && \
            # Install a few required packages
            apt install -y --no-install-recommends apt-transport-https gnupg ca-certificates curl dirmngr && \
            # Setup sury repos
            echo "deb https://packages.sury.org/php/ stretch main" >> /etc/apt/sources.list.d/sury.org.list && \
            curl -sS https://packages.sury.org/php/apt.gpg | apt-key add - && \
            # Setup MariaDB repos
            echo 'deb [arch=amd64,i386,ppc64el] http://mariadb.mirrors.ovh.net/MariaDB/repo/10.2/debian stretch main' > /etc/apt/sources.list.d/mariadb.list && \
            apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 && \
            # Update, upgrade
            apt update && \
            apt upgrade -y && \
            # Packages
            apt install -y --no-install-recommends \
                git supervisor \
                # Apache
            	apache2 \
                # MariaDB Server
            	mariadb-server \
                # PHP
                libapache2-mod-php7.1 php7.1-bc php7.1-cli php7.1-curl php7.1-gd php7.1-geoip \
                php7.1-imap php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-mysqlnd php7.1-odbc \
                php7.1-sqlite php7.1-ssh2 php7.1-tidy php7.1-xdebug php7.1-xsl php7.1-zip && \
            # Clean
            # Remove useless files installed for other PHP Versions
            rm -rf /usr/lib/php/20131226 /usr/lib/php/20151012  && \
            rm -rf /etc/php/5.6 /etc/php/7.0 && \
            # Remove useless packages / files
            apt purge --autoremove -y gnupg && \
            apt autoremove -y && \
            apt autoclean && \
            apt clean && \
            rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /var/cache/* /var/log/*

# Install Composer
RUN         php -r "copy('https://getcomposer.org/download/1.5.1/composer.phar', '/usr/local/bin/composer');" && \
            php -r "if (hash_file('SHA384', '/usr/local/bin/composer') === 'fd3800adeff12dde28e9238d2bb82ba6f887bc6d718eee3e3a5d4f70685a236b9e96afd01aeb0dbab8ae6211caeb1cbe') { \
                echo 'Composer installed'; \
            } else { \
                echo 'Hash invalid for downloaded composer.phar'; exit(1); \
            }" && \
            chmod 0755 /usr/local/bin/composer && \
            /usr/local/bin/composer selfupdate --stable

# Prepare Apache
RUN         sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
RUN         a2enmod rewrite
EXPOSE      80

# Prepare MariaDB
RUN         mkdir -p /var/log/mysql && chown mysql.mysql /var/log/mysql

# Prepare PHP
COPY        php-cli.ini    /etc/php/7.1/cli/conf.d/30-custom-php.ini
COPY        php-apache.ini /etc/php/7.1/apache2/conf.d/30-custom-php.ini
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
