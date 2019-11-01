#!/bin/bash
#功能描述(Description):打印9*9乘法表.

for ((i=1;i<=9;i++))
do
    for ((j=1;j<=i;j++))
    do
        echo -n "$i*$j=$[i*j] "
    done
    echo
done
