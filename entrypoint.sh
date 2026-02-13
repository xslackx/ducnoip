#!/usr/share/busybox/sh
noip-duc --daemonize -g all.ddnskey.com --username $NOIP_USERNAME --password $NOIP_PASSWORD 
#noip-duc --daemonize -g all.ddnskey.com --username $NOIP_USERNAME --password $NOIP_PASSWORD --check-interval $NOIP_CHECK_INTERVAL --daemon-group $NOIP_DAEMON_GROUP --daemon-user $NOIP_DAEMON_USER --http-timeout $NOIP_HTTP_TIMEOUT --log-level $NOIP_LOG_LEVEL



