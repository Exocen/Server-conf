#!/bin/bash

#  arch
#aurman -Syu --noedit --noconfirm nginx-mainline certbot-nginx
# debian
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
echo 'deb http://nginx.org/packages/mainline/debian/ stretch nginx' | sudo tee -a /etc/apt/sources.list
echo 'deb-src http://nginx.org/packages/mainline/debian/ stretch nginx' | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install nginx
sudo /bin/cp -fr html2 /usr/share/nginx/html2
sudo mkdir -p /etc/nginx/sites-enabled/
sudo /bin/cp -f nginx.conf /etc/nginx/
sudo /bin/cp -f default /etc/nginx/sites-enabled/
sudo systemctl enable nginx
sudo systemctl start nginx
sudo ./certbot-auto --nginx -n --agree-tos --rsa-key-size 4096 --register-unsafely-without-email -d HOSTNAME -d www.HOSTNAME
# auto certbot
sudo /bin/cp -f default_https /etc/nginx/sites-enabled/default
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048
sudo systemctl restart nginx
