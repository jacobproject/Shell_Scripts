#!/bin/bash
#功能描述(Description):猜数字小游戏,统计猜的次数.

num=$[RANDOM%100]
count=0
while :
do
    read -p "一个1-100的随机数,你猜是多少:" guess
    #使用正则匹配,判断是否输入了字母或符号等无效输入.
    [[ $guess =~ [[:alpha:]] ||  $guess =~ [[:punct:]] ]] && echo "无效输入." && exit
    let count++
    if [ $guess -eq $num ];then
        echo "恭喜,你猜对了,总共猜了$count次!"
        exit
    elif [ $guess -gt $num ];then
        echo "Oops,猜大了."
    else
        echo "Oops,猜小了."
    fi
done
