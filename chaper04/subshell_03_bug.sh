#!/bin/bash
#描述(Description):使用管道开启子Shell导致错误的案例演示.

sum=0
df | grep "^/" | while read name total used free other
do
    echo "free=$free"
    let sum+=free
    echo "sum=$sum"
done
echo $sum
