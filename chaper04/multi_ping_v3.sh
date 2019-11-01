#!/bin/bash
#Version:3.0
#功能描述(Description):控制进程数量的ping测试脚本.
#使用wait命令等待所有子进程结束后再退出脚本.

num=10             #控制进程数量.
net="192.168.4"
pipefile="/tmp/multiping_$$.tmp"

multi_ping() {
    ping -c2 -i0.2 -W1 $1 &>/dev/null
    if [ $? -eq 0 ];then
        echo "$1 is up."
    else
        echo "$1 is down."
    fi
}

#创建命名管道文件,创建其文件描述符,通过重定向导入数据到管道文件中.
mkfifo $pipefile
exec 12<>$pipefile
for i in `seq $num`
do
    echo "" >&12 &
done

#通过循环反复调用函数并将其放入后台并行执行.
#成功读取命名管道中的数据后开启新的进程.
#所有内容读取完后read被阻塞,无法再启动新进程.
#等待前面启动的进程结束后,继续往管道文件中写入数据,释放阻塞,再次开启新的进程.
for j in {1..254}
do
    read -u12
    {
        multi_ping $net.$j
        echo "" >&12
    } &
done
wait
rm -rf $pipfile
