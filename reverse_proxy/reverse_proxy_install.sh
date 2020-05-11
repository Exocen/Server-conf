#!/bin/bash

# install nginx
function install(){
    sudo rm /etc/nginx/sites-enabled/default
    sudo ln -s $HOME/default /etc/nginx/sites-enabled/default
    cd $HOME && wget https://dl.eff.org/certbot-auto && chmod a+x certbot-auto
}
# add to cron

LOG_DIR="$HOME/reverse_proxy_log"
if [ $# -eq 1 ]
then
    mkdir -p $LOG_DIR
    {
        cp default /tmp/default
        IP=`curl ipinfo.io/ip`
        sed -i 's/DESTINATION/'$IP'/g' /tmp/default
        scp /tmp/default $1:"default"
        ssh $1 ./certbot-auto --nginx -n --agree-tos --rsa-key-size 4096 --register-unsafely-without-email -d $1
        ssh $1 sudo systemctl restart nginx
    } 2>$LOG_DIR/reverse.err 1>$LOG_DIR/reverse.log
fi

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
