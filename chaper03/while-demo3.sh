#!/bin/bash
#功能描述(Description):while基本语法演示.

i=1
while [ $i -le 5 ]
do
    echo "$i"
    let i++
done
echo "-----------------------"
i=1
while [ $i -le 5 ]
do
    let i++
    echo "$i"
done
