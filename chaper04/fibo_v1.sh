#!/bin/bash
#功能描述(Description):使用数组推导斐波那契数列.
#F(n)=F(n-1)+F(n-2) (n>=3, F(1)=1,F(2)=1).

fibo=(1 1)
read -p "请输入需要计算的斐波那契数的个数:" num
for ((i=2;i<=$num;i++))
do
    let fibo[$i]=fibo[$i-1]+fibo[$i-2]
done
echo ${fibo[@]}
