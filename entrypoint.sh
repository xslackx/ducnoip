#!/usr/share/busybox/sh

app_help()
{
    hid="$1"
    err_="
    Must be one option.
    Options permited:
        basic - login only using username and password
        setd - use specific daemon user and group
        dtime - set interval and timeout in daemon mode with custom group and user
        otime - same dtime without daemon user and group
        all - set all options include log info
"
    if [ "$hid" = 'lt' ]; then
        echo "$err_"
        exit 1
    fi
    if [ "$hid" = 'notpermited' ]; then
        echo "$err_"
        exit 1
    fi
}

start_duc()
{
option=$1

if [ "$option" = "basic" ]; then
    noip-duc --daemonize -g all.ddnskey.com --username "$NOIP_USERNAME" --password "$NOIP_PASSWORD" 
    return "$!"
fi

if [ "$option" = "setd" ]; then
    noip-duc -g all.ddnskey.com --username "$NOIP_USERNAME" --password "$NOIP_PASSWORD" --daemon-group "$NOIP_DAEMON_GROUP" --daemon-user "$NOIP_DAEMON_USER"
    return "$!"
fi

if [ "$option" = "dtime" ]; then
    noip-duc --daemonize -g all.ddnskey.com --username "$NOIP_USERNAME" --password "$NOIP_PASSWORD" --check-interval "$NOIP_CHECK_INTERVAL" --daemon-group "$NOIP_DAEMON_GROUP" --daemon-user "$NOIP_DAEMON_USER" --http-timeout "$NOIP_HTTP_TIMEOUT"
    return "$!"
fi

if [ "$option" = "otime" ]; then
    noip-duc --daemonize -g all.ddnskey.com --username "$NOIP_USERNAME" --password "$NOIP_PASSWORD" --check-interval "$NOIP_CHECK_INTERVAL"  --http-timeout "$NOIP_HTTP_TIMEOUT"
    return "$!"
fi

if [ "$option" = "all" ]; then
    noip-duc --daemonize -g all.ddnskey.com --username "$NOIP_USERNAME" --password "$NOIP_PASSWORD" --check-interval "$NOIP_CHECK_INTERVAL" --daemon-group "$NOIP_DAEMON_GROUP" --daemon-user "$NOIP_DAEMON_USER" --http-timeout "$NOIP_HTTP_TIMEOUT" --log-level "$NOIP_LOG_LEVEL"
    return "$!"
fi

}

watchdog()
{
    pid="$1"
    while "$(test -e /proc/"$pid")"; do
        sleep 15
    done
    exit 1
}

main()
{
    user_option=$1

    if [ "$user_option" -lt 2 ]; then
        app_help lt

    fi

    for permited in "basic" "setd" "dtime" "otime" "all"; do
        if [ "$user_option" != "$permited" ]; then
            invalid=true
        fi
    done

    if [ "$invalid" ]; then app_help notpermited; fi

    nuc_pid=$(start_duc "$user_option")

    if [ "$nuc_pid" ]; then
        watchdog "$nuc_pid"
    fi

}

main "$1"