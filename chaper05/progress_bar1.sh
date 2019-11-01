#!/bin/bash
#功能描述(Description):为拷贝文件设计一个进度条效果.

#防止提前执行Ctrl+C后无法结束进度条.
trap 'kill $!' INT

#定义函数:实现无限显示不换行的#符号.
bar(){
    while :
    do
        echo -n '#'
        sleep 0.3
    done
}

#调用函数,屏幕显示#进度,直到拷贝结束kill杀死进度函数.
#$!变量保存的是最后一个后台进程的进程号.
bar &
cp -r $1 $2
kill $!
echo "拷贝结束!"
