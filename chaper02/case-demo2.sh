#!/bin/bash
#使用case进行字母比较
#模式与后面的命令序列之间的回车可有可无.

read -p "请输入一个a-c之间的字母:" key
case $key in
a)
    echo "I am a.";;&
#使用;;&会继续对后面的模式继续匹配,所以屏幕会继续显示后面的I am aa.
b)
    echo "I am b.";;
a)
#使用;&会导致后一个模式匹配中的命令被执行,所以屏幕会继续显示I am c.
    echo "I am aa.";&
c)
    echo "I am c.";;
a)
    echo "I am aaa.";;
*)
    echo "Out of range.";;
esac
