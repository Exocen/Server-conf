#!/bin/bash

LOCAL=`dirname "$(readlink -f "$0")"`
function install(){
    # install nginx
    cd $HOME && wget https://dl.eff.org/certbot-auto
    certbot_dir="/usr/bin/"
    certbot_name="certbot-auto"
    sudo chown root $HOME/$certbot_name
    sudo chmod 0755 $HOME/$certbot_name
    sudo mv $HOME/$certbot_name $certbot_dir
    sudo ./$certbot_dir/$certbot_name --nginx -d $1
    # get certifs
    sudo rm /etc/nginx/conf.d/default.conf
    sudo ln -s $HOME/default /etc/nginx/conf.d/default.conf
}

# add to cron

LOCAL=`dirname "$(readlink -f "$0")"`
LOG_DIR="$HOME/reverse_proxy_log"
if [ $# -eq 1 ]
then
    mkdir -p $LOG_DIR
    {
        cp $LOCAL/nginx_default /tmp/default
        IP=`curl ipinfo.io/ip`
        sed -i 's/DESTINATION/'$IP'/g' /tmp/default
        scp /tmp/default $1:"default"
        ssh $1 sudo certbot-auto renew --nginx -n --agree-tos --register-unsafely-without-email
        ssh $1 sudo systemctl restart nginx
    } 2>$LOG_DIR/reverse.err 1>$LOG_DIR/reverse.log
fi

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
