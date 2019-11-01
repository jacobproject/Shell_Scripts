#!/bin/bash
#功能描述(Description):通过简单的数字比较演示冒泡算法.

#使用数组保存用户输入的6个随机数.
for i in {1..6}
do
    read -p "请输入数字:" tmp
    if echo $tmp | grep -qP "\D" ;then
        echo "您输入的不是数字."
        exit
    fi
    num[$i]=$tmp
done
echo "您输入的数字序列为:${num[@]}"

#冒泡排序.
#使用i控制进行几轮的比较,使用j控制每轮比较的次数.
#对6个数字而言,需要5论比较,每进行一轮后,下一轮就可以少比较1次.
for ((i=1;i<=5;i++))
do
    for ((j=1;j<=$[6-i];j++))
    do
        if [ ${num[j]} -gt ${num[j+1]} ];then
            tmp=${num[j]}
            num[$j]=${num[j+1]}
            num[j+1]=$tmp
        fi    
    done
done
echo "经过排序后数字序列为:${num[@]}"
