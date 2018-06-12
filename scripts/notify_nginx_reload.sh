#!/bin/bash
#
#

dpkg --get-selections | grep -v deinstall | grep inotify-tools &> /dev/null
if [ $? -ne 0 ]
then
        echo "Installing inotify-tools, please wait..."
        apt-get -y install inotify-tools
fi
while true
do
        inotifywait --exclude .swp -e create -e modify  -e move  /etc/nginx/conf.d
        # Check NGINX Configuration Test
        # Only Reload NGINX If NGINX Configuration Test Pass
        nginx -t
        if [ $? -eq 0 ]
        then
                echo "Reloading Nginx Configuration after 30s"
                sleep 30
                service nginx reload
        fi
done