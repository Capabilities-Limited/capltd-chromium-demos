#!/bin/sh

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

NGINX="nginx"

if $(pkg64c check -d $NGINX); then
    echo "nginx installed"
else
    echo "Installing nginx"
    pkg64c install -y $NGINX
fi
if [ ! -e /usr/local/etc/nginx ]; then
    ln -s /usr/local/etc/nginx-cheri /usr/local/etc/nginx
fi
cp nginx.conf /usr/local/etc/nginx-cheri/nginx.conf
if [ ! -d /usr/local/www/dsbd-demo ]; then
    if $(pkg64 check -d wget); then
        echo "wget installed"
    else
        echo "Installing wget"
	pkg64 install -y wget
    fi
    wget -r -k -p --no-parent https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/
    mv www.cl.cam.ac.uk /usr/local/www/dsbd-demo
fi
rsync -rv exploits-demo/ /usr/local/www/exploits/

sysrc nginx_enable=YES
service nginx start
