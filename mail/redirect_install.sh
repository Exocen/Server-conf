#!/bin/bash

echo "What is your destination email ?"
read email
echo $email" ? (y/N)"
read answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ];then
    sudo bash -c 'echo "@$HOSTNAME "'$email' >> /etc/postfix/virtual'
    sudo bash -c ' echo "virtual_alias_maps = hash:/etc/postfix/virtual" >> /etc/postfix/main.cf'
    sudo postmap /etc/postfix/virtual
    sudo systemctl restart postfix
    echo 'Finish'
else
    echo 'Cancel'
fi
