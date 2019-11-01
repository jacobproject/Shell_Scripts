#!/bin/bash
#功能描述(Description):打印国际象棋棋盘.

for i in {1..8}
do
    for j in {1..8}
    do
        sum=$[i+j]
        if [[ $[sum%2] -ne 0 ]];then
            echo -ne "\033[41m  \033[0m"
        else
            echo -ne "\033[47m  \033[0m"
        fi
    done
    echo
done
