#!/bin/bash

# Add to cron
# @hourly path domain.com

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
