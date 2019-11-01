#!/bin/bash
#功能描述(Description):计数排序算法,v2版本.

#创建一个需要排序的数组.
num=(2 8 3 7 1 4 3 2 4 7 4 2 5 1 8 5 2 1 9)

#根据num数组的最大值创建一个对应空间大小的统计数组.
#该数组初始值都为0,哪怕没有的数据初始值也为0.
max=${num[0]}
for i in  `seq $[${#num[@]}-1]`
do
    [ ${num[i]} -gt $max ] && max=${num[i]}
done
for i in `seq 0 $max`
do
    count[$i]=0
done

#循环读取num数组中的每个元素值,以每个元素值为count数组的下标,做自加1的统计工作.
for i in `seq 0 $[${#num[@]}-1]`
do
    let count[${num[i]}]++
done

#使用循环读取count数组中每个元素值(也就是次数).
#根据次数打印对应下标.
for i in `seq 0 $[${#count[@]}-1]`
do
    for j in `seq ${count[i]}`
    do
        echo -n "$i "
    done
done
echo
