#!/bin/bash
#功能描述(Description):读取位置参数,测试是否空文件并删除空文件.

if [ $# -eq 0 ];then
    echo "用法:$0 文件名..."
    exit 1
fi

#测试位置变量个数，个数为0时循环结束.
while (($#))
do
    if [ ! -s $1 ];then
        echo -e "\033[31m$1为空文件,正在删除该文.\033[0m"
        rm -rf $1
    else
        [ -f $1 ] && echo -e "\033[32m$1为非空文件.\033[0m"
        [ -d $1 ] && echo -e "\033[32m$1为目录,不是文件名.\033[0m"
    fi
    shift
done
