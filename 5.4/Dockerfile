FROM debian:wheezy-slim
MAINTAINER Emmanuel Dyan <emmanuel.dyan@inetprocess.com>

# Create man directory to avoid java to crash on install
RUN mkdir -p /usr/share/man/man1

# Install Apache + PHP + MySQL Server + Java + Git
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \

    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \

    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \

    ca-certificates git supervisor wget \

	apache2 \

	mysql-server \

    default-jre-headless \

    libapache2-mod-php5 php-apc php5-cli php5-curl php5-gd php5-geoip php5-imagick php5-imap \
    php5-intl php5-json php5-ldap php5-mcrypt php5-memcached php5-mysql php5-odbc php5-pgsql \
    php5-sqlite php5-tidy php5-xdebug php5-xsl && \

    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/*

# Prepare PHP
COPY php-cli.ini    /etc/php5/cli/conf.d/30-custom-php.ini
COPY php-apache.ini /etc/php5/apache2/conf.d/30-custom-php.ini
RUN mkdir -p /var/log/php
RUN chown -R www-data:www-data /var/log/php
RUN php -r "copy('https://getcomposer.org/download/1.5.1/composer.phar', '/usr/local/bin/composer');" && \
    php -r "if (hash_file('SHA384', '/usr/local/bin/composer') === 'fd3800adeff12dde28e9238d2bb82ba6f887bc6d718eee3e3a5d4f70685a236b9e96afd01aeb0dbab8ae6211caeb1cbe') {echo 'Composer installed';} else {echo 'Hash invalid for downloaded composer.phar'; exit(1);}" && \
    chmod 0755 /usr/local/bin/composer && \
    /usr/local/bin/composer selfupdate --stable


# Prepare Apache
RUN mkdir -p /var/www/html
RUN mv /var/www/index.html /var/www/html/
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/sites-available/default*
RUN sed -i "s/\/var\/www/\/var\/www\/html/g" /etc/apache2/sites-available/default*
RUN a2enmod rewrite
EXPOSE 80


# Command
COPY run.sh     /run.sh
RUN  chmod +x    /run.sh

ENV ENVIRONMENT dev

VOLUME /var/lib/mysql

# Prepare supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Last step for services
CMD ["/run.sh"]
