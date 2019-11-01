#!/bin/bash
#功能描述(Description):随机点名抽奖器.

#按Ctrl+C时:恢复光标,恢复终端属性,清屏,退出脚本.
#防止程序意外中断导致的终端混乱.
trap 'tput cnorm;stty $save_property;clear;exit' 2

#定义变量:人员列表文件名,文件的行数,屏幕的行数,屏幕的列数.
name_file="name.txt"
line_file=$(sed -n '$=' $name_file)
line_screen=`tput lines`
column_screen=`tput cols`

#设置终端属性
save_property=$(stty -g)                    #保存当前终端所有属性.
tput civis                                  #关闭光标.

#随机抽取一个人名(随机点名).
while :
do
    tmp=$(sed -n "$[RANDOM%line_file+1]p" $name_file)
    #随机获取文件的某一行人名.
    tput clear                              #清屏.
    tput cup $[line_screen/4] $[column_screen/4]
    echo -e "\033[3;5H     随机点名器(按P停止):        "
    echo -e "\033[4;5H#############################"
    echo -e "\033[5;5H#                           #"
    echo -e "\033[6;5H#\t\t$tmp\t\t#"
    echo -e "\033[7;5H#                           #"
    echo -e "\033[8;5H#############################"
    sleep 0.1
    stty -echo
    read -n1 -t0.1 input
    if [[ $input == "p" || $input == "P" ]];then
        break
    fi
done
tput cnorm                                  #恢复光标.
stty $save_property                         #恢复终端属性.
