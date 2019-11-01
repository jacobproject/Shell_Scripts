#!/bin/bash
#功能描述(Description):根据用户选择的菜单实现对应的功能.

echo "请根据提示选择一个选项."
select item in "CPU" "IP" "MEM" "exit" 
do
    case $item in
    "CPU")
        uptime;;
    "IP")
        ip a s;;
    "MEM")
        free;;
    "exit")
        exit;;
    *)
        echo error;;
    esac
done
