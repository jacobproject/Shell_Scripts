#!/bin/bash
#功能描述(Description):一个错误演示脚本.

i=1
while [ $i -le 100 ]
do
echo "i=$i ; sum=$sum"
   let  sum+=i
done
echo $sum
