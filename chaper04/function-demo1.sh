#!/bin/bash
#功能描述(Description):函数中变量的作用域示例之全局变量.

#默认定义的变量为当前Shell全局有效.
global_var1="hello"
global_var2="world"

#定义demo函数,在函数体内定义新的变量以及修改函数外部的变量.
function demo() {
    echo -e "\033[46mfunction [demo] started...\033[0m"
    func_var="Topic:"
    global_var2="Broke Girls"
    echo "$func_var $global_var2"
    echo -e "\033[46mfunction [demo] end.\033[0m"
}

demo
echo
echo "$func_var $global_var1 $global_var2."
