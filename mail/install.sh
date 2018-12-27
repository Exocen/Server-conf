#!/bin/bash

sudo hostnamectl set-hostname HOSTNAME
aurman -Syu --noedit --noconfirm postfix postfix-policyd-spf-python
sudo /bin/cp main.cf /etc/postfix/main.cf -f
sudo /bin/cp master.cf /etc/postfix/master.cf -f
sudo postalias /etc/postfix/aliases
# openssl dhparam -out /etc/postfix/dhparam.pem 2048 # if no ssl

sudo systemctl enable postfix
sudo systemctl start postfix

echo "Do you want to redirect all your emails ?(y/N)"
read answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ];then
    sh ./redirect_install.sh
else
    echo 'Cancel'
fi
