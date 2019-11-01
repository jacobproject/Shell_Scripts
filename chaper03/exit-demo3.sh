#!/bin/bash
#功能描述(Description):exit基本语法演示.
#虽然脚本中cd命令的参数是错误的,屏幕也会返回错误信息.
#但是,exit指定了退出状态码,整个脚本的退出状态码为0.

ls /etc/passwd
cd -xyz
exit 0
