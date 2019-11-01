#!/bin/bash
#Version:1.0
#功能描述(Description):使用函数与&后台进程实现多进程ping测试.

net="192.168.4"

multi_ping() {
    ping -c2 -i0.2 -W1 $1 &>/dev/null
    if [ $? -eq 0 ];then
        echo "$1 is up."
    else
        echo "$1 is down."
    fi
}

#通过循环反复调用函数并将其放入后台并行执行.
for i in {1..254}
do
    multi_ping $net.$i &
done
