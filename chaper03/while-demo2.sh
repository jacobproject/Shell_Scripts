#!/bin/bash
#功能描述(Description):while基本语法演示.
#输出5次whllo world,输出变量i的值.

i=1
while [ $i -le 5 ]
do
    echo "hello world"
    echo "$i"
    let i++
done
