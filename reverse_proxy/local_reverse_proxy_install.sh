#!/bin/bash

LOCAL=`dirname "$(readlink -f "$0")"`

function nginx_install(){
    OS="NONE"
    if  [ -f /etc/os-release ]; then
        OS=`cat /etc/os-release | grep VERSION= | sed 's/^.*=//'`
    fi
    if [ "$OS" = "buster" ]; then
        # install nginx
        echo 'deb http://nginx.org/packages/mainline/debian/ buster nginx' | sudo tee -a /etc/apt/sources.list
        echo 'deb-src http://nginx.org/packages/mainline/debian/ buster nginx' | sudo tee -a /etc/apt/sources.list
        sudo apt update
        sudo apt intall nginx
    fi

}

function certbot_install(){
    # install certbot
    cd $HOME && wget https://dl.eff.org/certbot-auto
    certbot_dir="/usr/bin/"
    certbot_name="certbot-auto"
    sudo chown root $HOME/$certbot_name
    sudo chmod 0755 $HOME/$certbot_name
    sudo mv $HOME/$certbot_name $certbot_dir

    # get certifs
    sudo ./$certbot_dir/$certbot_name -d $1
    sudo rm /etc/nginx/conf.d/default.conf
    sudo ln -s $HOME/default /etc/nginx/conf.d/default.conf

}

function install(){
    sudo nginx -v
    if [ $? -eq 0 ]
    then
        sudo certbot-auto --version
        if [ $? -eq 0 ]
        then
            echo "Nginx and certbot installed"
        else
            certbot_install
        fi
    else
        nginx_install
        #TODO
        echo "Please rerun"
    fi
}

install

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
