#!/bin/bash
#使用case进行字母比较
#括号)前面的内容与后面的命令序列之间可以回车换行分隔,也可以没有换行.

read -p "请输入一个a-f之间的字母:" key
case $key in
a)
    echo "I am a.";;
b)
    echo "I am b.";;
c)  echo "I am c.";;
d)  echo "I am d.";;
e)
    echo "I am e.";;
f)
    echo "I am f.";;
*)
    echo "Out of range.";;
esac
