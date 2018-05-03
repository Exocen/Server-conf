#!/bin/bash

echo "Hostname ? :"
read hostname
echo $hostname" ? (y/N)"
read answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ];then
    echo 'Pre-install.....'
    sudo hostnamectl set-hostname $hostname
    sed -i 's/HOSTNAME/'$hostname'/g' website/default website/default_https website/install_web.sh mail/install.sh mail/main.cf mail/opendkim.conf
else
    echo 'Cancel'
fi

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
