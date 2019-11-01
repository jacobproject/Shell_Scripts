#!/bin/bash
#功能描述(Description):C语言风格的for循环示例.
#i初始值为1,j初始值为5
#每循环一次对i进行自加1运算、对j进行自减1运算,当i大于5则循环结束.

for ((i=1,j=5;i<=5;i++,j--))
do
    echo "$i $j"
done
