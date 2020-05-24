#!/bin/bash

certbot_dir="/usr/bin/"
certbot_name="certbot-auto"
OS="NONE"
LOCAL=`dirname "$(readlink -f "$0")"`

function nginx_install(){
    if  [ -f /etc/os-release ]; then
        OS=`cat /etc/os-release | grep VERSION= | sed 's/^.*=//'`
    fi
    if [ "$OS" = "buster" ]; then
        # install nginx
        sudo wget https://nginx.org/keys/nginx_signing.key
        sudo apt-key add nginx_signing.key
        sudo rm nginx_signing.key
        add_ppa 'deb http://nginx.org/packages/mainline/debian/ $OS nginx'
        add_ppa 'deb-src http://nginx.org/packages/mainline/debian/ $OS nginx'
        sudo apt update
        sudo apt install nginx
    fi
}

add_ppa() {
  for i in "$@"; do
    grep -h "^deb.*$i" /etc/apt/sources.list > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Adding ppa:$i"
        echo '$i' | sudo tee -a /etc/apt/sources.list
    else
      echo "ppa:$i already exists"
    fi
  done
}

function certbot_install(){
    # install certbot
    cd $HOME && wget https://dl.eff.org/certbot-auto
    sudo chown root $HOME/$certbot_name
    sudo chmod 0755 $HOME/$certbot_name
    sudo mv $HOME/$certbot_name $certbot_dir

    # get certifs
    sudo ./$certbot_dir/$certbot_name -d $1
    sudo rm /etc/nginx/conf.d/default.conf
    sudo ln -s $HOME/default /etc/nginx/conf.d/default.conf

}

function install(){
    sudo /usr/sbin/nginx -v
    if [ $? -eq 0 ]
    then
        sudo ./$certbot_dir/$certbot_name --version
        if [ $? -eq 0 ]
        then
            echo "Nginx and certbot installed"
        else
            certbot_install
        fi
    else
        nginx_install
        install
    fi
}

install

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
