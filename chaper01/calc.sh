#!/bin/bash
#计算1+2+3...+n的和,可以使用n*(n+1)/2公式快速计算结果
read -p "请输入一个正整数:" num
sum=$[num*(num+1)/2]
echo -e "\033[32m$num以内整数的总和是:$sum\033[0m"

#使用三角形的底边和高计算面积:A=1/2bh
read -p "请输入三角形底边长度:" bottom
read -p "请输入三角形高度:" hight
A=$(echo "scale=1;1/2*$bottom*$hight" | bc)
echo -e "\033[32m三角形面积是:$A\033[0m"

#梯形面积:(上底+下底)*高/2
read -p "请输入梯形上底:" a
read -p "请输入梯形下底:" b
read -p "请输入梯形高度:" h
A=$(echo "scale=2;($a+$b)*$h/2" | bc)
echo -e "\033[32m梯形面积是:$A\033[0m"


#使用A=πr^2计算圆的面积,取2位小数π=3.14
read -p "请输入圆的半径:" r
A=$(echo "scale=2;3.14*$r^2" | bc)
echo -e "\033[32m圆的面积是:$A\033[0m"

echo "3282820KiB等于多少GiB?"
G=$(echo "32828920/1024/1024" | bc)
echo -e "\003[32m答案${G}G\033[0m"
#注意使用{}防止变量名歧义

#时间格式转化
read -p "请输入秒数:" sec
ms=$[sec*1000]
echo -e "\033[32m$sec秒=$ms毫秒\033[0m"
us=$[sec*1000000]
echo -e "\033[32m$sec秒=$us微秒\033[0m"
hour=$(echo "scale=2;$sec/60/60"|bc)
echo -e "\033[32m$sec秒=$hour小时\033[0m"

