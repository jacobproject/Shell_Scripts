#!/bin/bash
if [ -z $1 ];then
    echo "错误:未输入服务名称."
    echo "用法:脚本名 服务器名称."
    exit
fi
if systemctl is-active $1 &>/dev/null ;then
    echo "$1已经启动..."
else
    echo "$1未启动..."
fi
if systemctl is-enabled $1 &>/dev/null ;then
    echo "$1是开机自启动项."
else
    echo "$1不是开机自启动项."
fi
