#!/bin/bash

echo "当前账户是:$USER,当前账户的UID是:$UID"
echo "当前账户的家目录是:$HOME"
echo "当前工作目录是:$PWD"
echo "返回0-32767的随机数:$RANDOM"
echo "当前脚本的进程号是$$"
echo "当前脚本的名称为:$0"
echo "当前脚本的第1个参数是:$1"
echo "当前脚本的第2个参数是:$2"
echo "当前脚本的第3个参数是:$3"
echo "当前脚本的所有参数是:$*"
echo "准备创建一个文件..."
touch "$*"
echo "准备创建多个文件..."
touch "$@"

ls /etc/passwd
echo "我是正确的返回状态码:$?,因为上一条命令执行结果没有问题"

ls /etc/pas
echo "我是错误的返回状态码:$?,因为上一条命令执行结果有问题，提示无此文件"

