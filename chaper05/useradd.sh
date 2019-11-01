#!/bin/bash
#功能(Description):创建系统账户并配置密码.

#判断未输入变量值时报错并退出脚本.
read -p "请输入账户名称:"  username
username=${username:?"未输入账户名称,请重试."}

#如果pass变量被赋值,则直接使用该值.如果pass未被赋值,则设置初始密码.
read -p "请输入账户密码,默认密码为[123456]:"  pass
pass=${pass:-123456}

if id $username &> /dev/null ;then
    echo "账户:$username已存在."
else
    useradd $username
    echo "$pass" | passwd --stdin $username &> /dev/null
    echo -e "\033[32m[OK]\033[0m"
fi

