#!/bin/bash

#创建命名管道文件,并绑定固定的文件描述符.
pipefile=/tmp/procs_$$.tmp
mkfifo $pipefile
exec 12<>$pipefile

#通过文件描述符往命名管道中写入5行任意数据,用于控制进程数量.
for i in {1..5}
do
    echo "" >&12 &
done

#通过read命令的-u选项指定从特定的文件描述符中读取数据行.
#每次读取一行,每读取一行就启动一个耗时的进程sleep,并放入后台执行.
#因为命名管道中只要5行数据,读取5行后read会被阻塞,也就无法继续启动sleep进程.
#每当任意一个sleep进程结束,就通过文件描述符再写入任意数据到命名管道.
#当管道中有数据后,read则可以继续读取数据,继续开启新的进程,依次类推.
for j in {1..20}
do
    read -u12
    {
        echo -e "\033[32mstart sleep No.$j\033[0m"
        sleep 5
        echo -e "\033[31mstop sleep No.$j\033[0m"
        echo "" >&12
    } &
done
wait
rm -rf $pipefile
