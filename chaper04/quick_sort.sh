#!/bin/bash
#功能描述(Description):采用分治思想的冒泡算法改进算法快速排序(快排).

#初始化一个数组.
num=(5 3 8 4 7 9 2)

#定义一个可以递归调用的快速排序的函数.
quick_sort(){
    #先判断需要比较的数字个数,$1是数组最左边的坐标,$2是数组最右边的坐标.
    #左边的坐标要小于右边坐标,否则表示需要排序的数字只有一个,不需要排序可以直接退出函数.
    if [ $1 -ge $2 ];then
        return
    fi

    #定义局部变量,base为基准数字,这里我们选择的是最左边的数字num[$1].
    #i表示左边的坐标,right表示右边的坐标(也可以使用i和j表示左右坐标).
    local base=${num[$1]}
    local left=$1
    local right=$2

    #把要排序的数字序列中,比基准数大的放右边,比基准数小的放左边.
    while [ $left -lt $right ]
    do
        #right向左移动,找比基准数(base)小的元素.
        while [[ ${num[right]} -ge $base && $left -lt $right ]]
        do
            let right--
        done
        #left向右移动,找比基准数(base)大的元素.
        while [[ ${num[left]} -le $base && $left -lt $right ]]
        do
            let left++
        done
        #将left坐标元素和right坐标元素交换.
        if [ $left -lt $right ];then
            local tmp=${num[$left]}
            num[$left]=${num[right]}
            num[$right]=$tmp
        fi
    done

    #将基准数字与left坐标元素交换.
    num[$1]=${num[left]}
    num[left]=$base

    #递归调用快速排序算法,对i左边的元素实施快速排序工作.
    quick_sort $1 $[left-1]
    #递归调用快速排序算法,对i右边的元素实施快速排序工作.
    quick_sort $[left+1] $2
}

#调用函数对数组排序,排序后输出数组的所有元素.
quick_sort 0 ${#num[@]}
echo ${num[*]}
