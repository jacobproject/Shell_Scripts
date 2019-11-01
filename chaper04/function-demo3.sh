#!/bin/bash
#功能描述(Description):函数中变量的作用域示例.

#函数体外部的数组和关联数组都是全局变量.
a=(aa bb cc)
declare -A b
b[a]=11
b[b]=22

#定义demo函数.
#在函数体内定义新的普通数组为全局变量.
#在函数体内定义新的关联数组为局部变量.

function demo() {
a=(xx yy zz)
declare -A b
b[a]=88
b[b]=99
echo ${a[@]}
echo ${b[@]}
}

demo
echo ${a[@]}
echo ${b[@]}
