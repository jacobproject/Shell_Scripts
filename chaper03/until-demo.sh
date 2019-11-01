#!/bin/bash
#until语句仅当条件判断为真时才退出循环.

i=1
until [ $i -ge 5 ]
do
    echo $i
    let i++
done
