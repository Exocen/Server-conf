#!/bin/bash

# Add to cron
# @hourly path domain.com

LOG_DIR="$HOME/reverse_proxy_log"
LOCAL=`dirname "$(readlink -f "$0")"`
TMP="/tmp/default.conf"

if [ $# -eq 1 ]
then
    mkdir -p $LOG_DIR
    {
        rm $TMP
        cp $LOCAL/nginx_default $TMP
        IP=`curl -s ipinfo.io/ip`
        sed -i 's/DESTINATION/'$IP'/g' $TMP
        DIFF=`diff -q /tmp/default  <(ssh $1 cat default.conf)`
        if [ "$DIFF" != "" ]; then
            scp -q $TMP $1:"default.conf"
            ssh $1 sudo systemctl restart nginx
        else
            echo "Ip unchanged"
        fi
        ssh $1 sudo certbot-auto renew --nginx -n --agree-tos --register-unsafely-without-email
    } 2>$LOG_DIR/reverse.err 1>$LOG_DIR/reverse.log
        fi

# Local Variables:
# mode: Shell-script
# coding: mule-utf-8
# End:
