#!/bin/bash
#描述(Description):使用&后台进程开启子Shell.

count=0
for i in {1..254}
do
    ping -c1 -i0.2 -W1 192.168.4.$i >/dev/null  && let count++ &
done
echo $count
