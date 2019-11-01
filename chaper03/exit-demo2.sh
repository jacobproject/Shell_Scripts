#!/bin/bash
#功能描述(Description):exit基本语法演示.
#exit不指定退出状态码时,返回上一个命令的退出状态码.
#exit前面的命令是cd,命令不会出错,脚本退出后的状态码会是0.

ls /etc/passwd
cd
exit
