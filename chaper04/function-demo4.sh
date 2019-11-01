#!/bin/bash
#功能描述(Description):函数中变量的作用域示例.

#默认定义的变量为当前Shell全局有效.
global_var1="hello"
global_var2="world"

#定义demo函数,在函数体内定义新的局部变量并修改局部变量.
function demo() {
    func_var="Test"
    global_var2="Broke Girls"
    echo "全局变量:$global_var1 $global_var2"
}

echo "函数内部变量:[$func_var]"
echo "$global_var1 $global_var2."
