#!/bin/bash
#功能描述(Description):while基本语法演示.
#通过grep过滤httpd，检测httpd服务是否为启动状态.

while ps aux | grep -v grep | grep -q httpd
do
    clear
    echo "      httpd运行状况:              "
    echo "----------------------------------"
    echo -e "\033[32mhttpd 正在运行中...\033[0m"
    echo "----------------------------------"
    sleep 0.5
done
    echo "httpd 被关闭"
