#!/bin/bash
#功能描述(Description):使用字串截取的方式生成随机密码.

#定义变量:10个数字+52个字符.
key="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

randpass(){
    if [ -z "$1" ];then
        echo "randpass函数需要一个参数,用来指定提取的随机数个数."
        return 127
    fi
#调用$1参数,循环提取任意个数据字符.
#用随机数对62取余数,返回的结果为[0-61].
    pass=""
    for i in `seq $1`
    do
        num=$[RANDOM%${#key}]
        local tmp=${key:num:1}
        pass=${pass}${tmp}
    done
    echo $pass
}

#randpass 8
#randpass 16

#创建临时测试账户,为账户配置随机密码,并将密码保存至/tmp/pass.log.
useradd tomcat
passwd=$(randpass 6)
echo $passwd | passwd --stdin tomcat
echo $passwd > /tmp/pass.log
