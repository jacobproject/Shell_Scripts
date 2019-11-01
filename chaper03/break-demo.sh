#!/bin/bash
#功能描述(Description):break基本语法演示.

for i in {1..5}
do
    [ $i -eq 3 ] && break
    echo $i
done
echo "game over."
