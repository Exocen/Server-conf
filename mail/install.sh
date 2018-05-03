#!/bin/bash

sudo hostnamectl set-hostname HOSTNAME
yaourt -Sy postfix python-postfix-policyd-spf opendkim --noconfirm
sudo /bin/cp main.cf /etc/postfix/main.cf -f
sudo /bin/cp master.cf /etc/postfix/master.cf -f
sudo postalias /etc/postfix/aliases
# openssl dhparam -out /etc/postfix/dhparam.pem 2048 # if no ssl

sudo /bin/cp opendkim.conf /etc/opendkim/opendkim.conf -f
sudo opendkim-genkey -r -s myselector --directory=/etc/opendkim/ -d HOSTNAME

sudo systemctl enable postfix opendkim
sudo systemctl start postfix opendkim

# DKIM selector value :
echo "cat /etc/opendkim/myselector.txt"

echo "Do you want to redirect all your emails ?(y/N)"
read answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ];then
    sh ./redirect_install.sh 
else
    echo 'Cancel'
fi
