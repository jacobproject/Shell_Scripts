#!/bin/bash
# chkconfig: 2345 90 98
#描述:CentOS6的Nginx服务启动脚本.
#备注:CentOS7向下兼容CentOS6的启动脚本.
#暂时没有使用函数功能,如果使用函数脚本会更加简洁.

nginx="/usr/local/nginx/sbin/nginx"
pidfile="/usr/local/nginx/logs/nginx.pid"

case $1 in
start)
    if [ -f $pidfile ];then
        echo -e "\033[91mNginx is already running...\033[0m"
        exit
    else
        $nginx && echo -e "\033[32mNginx is already running...\033[0m"
    fi;;
stop)
    if [ ! -f $pidfile ];then
        echo -e "\033[91mNginx is already stoped.\033[0m"
        exit
    else
        $nginx -s stop && echo -e "\033[32mNginx is stoped.\033[0m"
    fi;;
restart)
    if [ ! -f $pidfile ];then
        echo -e "\033[91mNginx is already stoped.\033[0m"
        echo -e "\033[91mPlease to run Nginx first.\033[0m"
        exit
    else
        $nginx -s stop && echo -e "\033[32mNginx is stoped.\033[0m"
    fi
    $nginx  && echo -e "\033[32mNginx is running...\033[0m"
    ;;
status)
    if [ -f $pidfile ];then
        echo -e "\033[32mNginx is running...\033[0m"
    else
        echo -e "\033[32mNginx is stoped.\033[0m"
    fi;;
reload)
    if [ ! -f $pidfile ];then
        echo -e "\033[91mNginx is already stoped.\033[0m"
        exit
    else
        $nginx -s reload && echo -e "\033[32mReload configure done.\033[0m"
    fi;;
*)
    echo "Usage:$0 {start|stop|restart|status|reload}";;
esac
