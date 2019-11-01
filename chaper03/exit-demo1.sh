#!/bin/bash
#功能描述(Description):exit基本语法演示.

for i in {1..5}
do
    [ $i -eq 3 ] && exit
    echo $i
done
echo "game over."
