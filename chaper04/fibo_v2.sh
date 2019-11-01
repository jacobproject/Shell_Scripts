#!/bin/bash
#功能描述(Description):使用数组推导斐波那契数列.
#F(n)=F(n-1)+F(n-2) (n>=3, F(1)=1,F(2)=1).

#定义函数.
Fibonacci() {
#前面两个斐波那契数不需要计算,直接设置为1即可.
    if [[ $1 -eq 1 || $1 -eq 2 ]];then
        echo -n "1 "
    else
#后面的斐波那契数永远都是前面两个数的和.
        echo -n "$[$(Fibonacci $[$1-1])+$(Fibonacci $[$1-2])] "
    fi
}

for i in {1..10}
do
    Fibonacci $i
done
echo 
