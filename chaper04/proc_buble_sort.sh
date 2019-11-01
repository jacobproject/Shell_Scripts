#!/bin/bash
#功能描述(Description):根据进程所占物理内存的大小对进程排序.

#保存当前系统所有进程的名称及其所占物理内存大小的数据到临时文件.
tmpfile="/tmp/procs_mem_$$.txt"
ps --no-headers -eo comm,rss > $tmpfile


#定义函数实现冒泡排序.
#使用i控制进行几轮的比较,使用j控制每轮比较的次数.
#使用变量len读取数组个数,根据内存大小排序,并且调整对应的进程名称的顺序.
bubble() {
local i j
local len=$1
for ((i=1;i<=$[len-1];i++))
do
    for ((j=1;j<=$[len-i];j++))
    do
        if [ ${mem[j]} -gt ${mem[j+1]} ];then
            tmp=${mem[j]}
            mem[$j]=${mem[j+1]}
            mem[j+1]=$tmp
            tmp=${name[j]}
            name[$j]=${name[j+1]}
            name[j+1]=$tmp
        fi    
    done
done
echo "排序后进程序列:"
echo "---------------------------------------------"
echo "${name[@]}"
echo "---------------------------------------------"
echo "${mem[@]}"
echo "---------------------------------------------"
}

#使用两个数组(name,mem)分别保存进程名称和进程所占内存大小.
i=1
while read proc_name proc_mem
do
    name[$i]=$proc_name
    mem[$i]=$proc_mem
    let i++
done < $tmpfile
rm -rf $tmpfile
#调用函数,根据内存大小对数据进行排序.
bubble ${#mem[@]}
