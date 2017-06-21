#!/bin/bash
set -e
if [ -z "$1" -o ! -d "$1" ]; then
    echo "You must define a valid PHP version to build as parameter"
    exit 1
fi
cd $1
docker build -t "inet_lamp_full_test" .
echo ""
echo ""
if [ $? -eq 0 ]; then
    echo -e "\x1b[1;32mBuild Done. To run it: \e[0m"
    echo 'docker run -d --rm --hostname "lamp-full-ctn" --name "lamp-full-ctn" inet_lamp_full_test'
    echo 'docker exec -i -t "lamp-full-ctn" /bin/bash'
    echo "Once Done : "
    echo 'docker stop "lamp-full-ctn"'
fi
