#!/bin/bash
# We'll say that we are by default in dev
echo "; configuration for php xhprof module
extension=xhprof.so" > /etc/php5/conf.d/xhprof.ini
echo "; configuration for php xdebug module
zend_extension=/usr/lib/php5/20090626/xdebug.so" > /etc/php5/conf.d/xdebug.ini

sed -i 's/^display_errors\s*=.*/display_errors = On/g' /etc/php5/fpm/conf.d/30-custom-php.ini
sed -i 's/^max_execution_time\s*=.*/max_execution_time = -1/g' /etc/php5/fpm/conf.d/30-custom-php.ini

# If prod has been set ... "clean"
if [ "$ENVIRONMENT" != "dev" ]; then
    echo "; configuration for php xhprof module
; extension=xhprof.so" > /etc/php5/conf.d/xhprof.ini
    echo "; configuration for php xdebug module
; zend_extension=/usr/lib/php5/20090626/xdebug.so" > /etc/php5/conf.d/xdebug.ini
    sed -i 's/^display_errors\s*=.*/display_errors = Off/g' /etc/php5/fpm/conf.d/30-custom-php.ini
    sed -i 's/^max_execution_time\s*=.*/max_execution_time = 60/g' /etc/php5/fpm/conf.d/30-custom-php.ini
fi

ping_apache() {
    (exec 6<>/dev/tcp/127.0.0.1/80 ) >/dev/null 2>&1
}

ping_mysql() {
    mysqladmin ping >/dev/null 2>&1
}

check_service() {
    local service="$1"
    local ping_cmd="$2"
    echo -n "Check $service "
    for retry in {1..100}
    do
        $ping_cmd
        if [ "$?" -eq "0" ]
        then
            echo " $service Started"
            break
        fi
        echo -n "."
        sleep .1
    done
    if [ "$retry" -eq "100" ]
    then
        echo " Unable to start $service"
        exit 1
    fi
}

if [ "x$1" == "x--detach" ]
then
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
    # Test if apache is started
    check_service Apache "ping_apache"
    check_service MySQL "ping_mysql"
else
    exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
fi
