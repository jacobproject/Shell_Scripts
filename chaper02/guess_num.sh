#!/bin/bash
#功能描述(Description):脚本自动生成10以内的随机数,根据用户的输入,输出判断结果.

clear
num=$[RANDOM%10+1]
read -p "请输入1-10之间的整数:" guess

if [ $guess -eq $num ];then
    echo "恭喜,猜对了,就是:$num"
elif [ $guess -lt $num ];then
    echo "Oops,猜小了."
else
    echo "Oops,猜大了."
fi
