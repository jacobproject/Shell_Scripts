#!/bin/bash
#功能描述(Descrtiption):机选双色球.
#红色球1-33,蓝色球1-16,红色球号码不可以重复.
#6组双色球,1组蓝色球.

RED_COL='\033[91m'
BLUE_COL='\033[34m'
NONE_COL='\033[0m'
red_ball=""

#随机选择1-33的红色球(6个),1-16的篮球(1个).
#每选出一个号码通过+=的方式存储到变量中.
#通过grep判断新选出的红球是否已经出现过,-w选项是过滤单词.
while :
do
    clear
    echo "---机选双色球---"
    tmp=$[RANDOM%33+1]
    echo "$red_ball" | grep -q -w $tmp && continue
    red_ball+=" $tmp"
    echo -en "$RED_COL$red_ball$NONE_COL"
    word=$(echo "$red_ball" | wc -w)
    if [ $word -eq 6 ]; then
        blue_ball=$[RANDOM%16+1]
        echo -e "$BLUE_COL $blue_ball$NONE_COL"
        break
    fi
    sleep 0.5
done
    

