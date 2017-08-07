FROM debian:squeeze
MAINTAINER Emmanuel Dyan <emmanuel.dyan@inetprocess.com>

# Because the official image does not have the right repos
RUN echo "deb http://archive.debian.org/debian/ squeeze main contrib non-free" > /etc/apt/sources.list

# DotDeb configuration and upgrade the system
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \

    # Install curl + certs to have dotdeb
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl && \

    echo "deb http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
    curl -sS http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \

    # Update again, upgrade, install all packages
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \

    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \

    git supervisor wget \

	apache2 \

	mysql-server \

    libapache2-mod-php5 php5-apc php5-cli php5-curl php5-ffmpeg php5-fpm php5-gd php5-geoip php5-imagick php5-imap \
    php5-intl php5-json php5-ldap php5-mcrypt php5-memcached php5-mysql php5-odbc php5-pgsql \
    php5-sqlite php5-ssh2 php5-xdebug php5-xsl && \

    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/*


# Prepare PHP
COPY php-cli.ini    /etc/php5/cli/conf.d/30-custom-php.ini
COPY php-apache.ini /etc/php5/apache2/conf.d/30-custom-php.ini
RUN mkdir -p /var/log/php
RUN chown -R www-data:www-data /var/log/php
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer && \
	php -r "unlink('composer-setup.php');"
RUN rm -f /etc/php5/conf.d/xhprof.ini

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

# Prepare supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Last step for services
CMD ["/run.sh"]
