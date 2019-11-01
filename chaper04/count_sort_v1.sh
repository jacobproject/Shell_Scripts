#!/bin/bash
#功能描述(Description):计数排序算法,v1版本.

#创建一个需要排序的数组.
num=(2 8 3 7 1 4 3 2 4 7 4 2 5 1 8 5 2 1 9)
#需要排序的数组中最大值为9,因此创建可以存10个数字的数组,初始值都为0.
count=(0 0 0 0 0 0 0 0 0 0)

#num数组中有19个数,下标为0-18,使用循环读取num每个元素的值.
#以每个元素的值为count数组的下标,做自加1的统计运算.
for i in `seq 0 18`
do
    let count[${num[i]}]++
done

#使用循环读取count数组中每个元素值(也就是次数).
#根据次数打印对应下标.
for i in `seq 0 9`
do
    for j in `seq ${count[i]}`
    do
        echo -n "$i "
    done
done
echo
