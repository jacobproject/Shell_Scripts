#!/bin/bash
#功能描述(Description):通过trap捕获信号.

trap 'echo "打死不中断|睡眠.";sleep 3' INT TSTP
trap 'echo 测试;sleep 3' HUP

while :
do
    echo "signal"
    echo "demo"
done
