#!/bin/bash

LOCAL=`dirname "$(readlink -f "$0")"`
# install nginx
function install(){
    cd $HOME && wget https://dl.eff.org/certbot-auto && chmod a+x certbot-auto
    ./certbot-auto
    sudo rm /etc/nginx/sites-enabled/default
    sudo ln -s $HOME/default /etc/nginx/sites-enabled/default
}
# add to cron

LOG_DIR="$HOME/reverse_proxy_log"
if [ $# -eq 1 ]
then
    mkdir -p $LOG_DIR
    {
        cp $LOCAL/nginx_default /tmp/default
        IP=`curl ipinfo.io/ip`
        sed -i 's/DESTINATION/'$IP'/g' /tmp/default
        scp /tmp/default $1:"default"
        ssh $1 ./certbot-auto renew --nginx -n --agree-tos --register-unsafely-without-email
        ssh $1 sudo systemctl restart nginx
    } 2>$LOG_DIR/reverse.err 1>$LOG_DIR/reverse.log
fi

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
