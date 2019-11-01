#!/bin/bash
#功能描述(Description):为拷贝文件设计一个进度条效果.

#防止提前执行Ctrl+C后无法结束进度条.
trap 'kill $!' INT

#定义变量,存储源与目标的容量大小,目标初始大小为0.
src=$(du -s $1 | cut -f1)
dst=0

#定义函数:实时对比源文件与目标文件的大小,计算拷贝进度.
bar() {
    while :
    do
        size=$(echo "scale=2;$dst/$src*100" | bc)
        echo -en "\r|$size%|"
        [ -f $2 ] && dst=$(du -s $2 | cut -f1)
        [ -d $2 ] && dst=$(du -s $2/$1 | cut -f1)
        sleep 0.3
    done
}

bar $1 $2 &
cp -r $1 $2
kill $!
echo "拷贝结束!"
