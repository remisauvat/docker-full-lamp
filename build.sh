#!/bin/bash
set -e
if [ -z "$1" -o ! -d "$1" ]; then
    echo "You must define a valid PHP version to build as parameter"
    exit 1
fi
cd $1
docker build -t "inet_lamp_full_test" .
echo ""
echo "To launch the VM:"
echo 'docker stop "lamp-full"'
echo 'docker rm "lamp-full"'
echo 'docker run -d --hostname "lamp-full-ctn" --name "lamp-full" inet_lamp_full_test'
echo 'docker exec -i -t "lamp-full" /bin/bash'
echo -e "\x1b[1;32mBuild Done\e[0m"
