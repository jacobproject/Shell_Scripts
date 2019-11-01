#!/bin/bash
#功能描述(Description):自定义函数返回码.

#默认以函数中最后一条命令的状态作为返回码.
demo1() {
    uname  -r
}

#使用return可以让函数立刻结束,并返回状态码,return的有效范围为0-255.
demo2(){
    echo "start demo2"
    return 100
    echo "demo2 end."
}

#如果使用exit定义函数的返回码,则执行函数会导致脚本退出.
demo3() {
    echo "hello"
    exit
}

demo1
echo "demo1 status: $?"
demo2
echo "demo2 status: $?"
demo3
echo "demo3 status :$?"
