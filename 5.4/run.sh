#!/bin/bash
# We'll say that we are by default in dev
php5enmod xdebug
sed -i 's/^display_errors\s*=.*/display_errors = On/g' /etc/php5/apache2/conf.d/30-custom-php.ini
sed -i 's/^max_execution_time\s*=.*/max_execution_time = -1/g' /etc/php5/apache2/conf.d/30-custom-php.ini

# If prod has been set ... "clean"
if [ "$ENVIRONMENT" != "dev" ]; then
    php5dismod xdebug
    sed -i 's/^display_errors\s*=.*/display_errors = Off/g' /etc/php5/apache2/conf.d/30-custom-php.ini
    sed -i 's/^max_execution_time\s*=.*/max_execution_time = 60/g' /etc/php5/apache2/conf.d/30-custom-php.ini
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

