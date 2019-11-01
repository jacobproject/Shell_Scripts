#!/bin/bash
#测试计算机的CPU品牌是AMD还是Intel。
#grep的-q选项，可以让grep进入静默模式，不管过滤到数据还是没有，都不显示输出结果。
#if命令会通过grep命令的返回值自动判断是否过滤到数据。

if grep -q AMD /proc/cpuinfo; then
echo "AMD CPU"
fi
if grep -q Intel /proc/cpuinfo; then
echo "Intel CPU"
fi

