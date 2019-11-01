#!/bin/bash
#识别用户输入字符的类型(进化版).

shopt -s extglob
read -p "请输入任意字符:" key
case $key in
+([[:lower:]]))
    echo "您输入的是小写字母.";;
+([[:upper:]]))
    echo "您输入的是大写字母.";;
+([0-9]))
    echo "您输入的是数字.";;
*)
    echo "您输入的是其他特殊符号.";;
esac
