#!/bin/bash
#功能描述(Description):文字组合拼接游戏.

tmpfile="/tmp/puzzle-$$.txt"
#正确的英文原文
cat > $tmpfile << EOF
The best hearts are always the bravest.
History teaches, but it has no pupils.
Dreams are the food of human progress.
Questions can't change the truth. But they give it motion.
We can only see a short distance ahead, but we can see plenty there that needs to be done.
Endeavor to see the good in every situation.
Life is not a problem to be solved, but a reality to be experienced.
Love is composed of a single soul inhabiting two bodies.
Everyone can rise above their circumstances and achieve success if they are dedicated to and passionate about what they do.
Nothing is impossible, the word itself says I'm possible!
Life isn't about finding yourself. Life is about creating yourself.
EOF

#定义函数:随机读取文件的行.
get_line(){
    local num=$[RANDOM%`cat $1 | wc -l`+1]
    line=`head -$num $1 | tail -1`
}

#定义函数:将文件行中的所有单词拆散并保存到数组word中.
break_line(){
    index=0
    for i in $line
    do
        word[$index]=$i
        let index++
    done
}

#定义函数:随机输出数组中所有元素的值.
get_word(){
   while :
   do
       #统计数组最大值,使用随机数对最大值取余,例如:数组中有8个单词,则对8取余(0-7).
       local max=${#word[@]}
       local num=$[RANDOM%max]
       #将已经提取的随机数组下标保存到tmp临时变量,如果下标已经在tmp中则不再显示该下标的值.
       #如果随机下标没有在tmp变量中,则显示对应数组下标的值(也就是某个单词).
       if ! echo $tmp | grep -qw $num ;then
            echo -n "${word[num]}  "
            local tmp="$tmp $num"
       fi
       #判断当所有下标都提取完成后退出while循环.
       if [ `echo $tmp | wc -w` -eq ${#word[@]} ];then
           break
       fi
   done
   echo;echo
}

#调用函数完成单词拼接游戏.
get_line $tmpfile
break_line
clear
echo "-------------------------------------------------"
echo -e "\033[34m尝试将下面的单词重新组合为一个完整的句子:\033[0m"
echo "-------------------------------------------------"
get_word

#读取用户的输入信息,并通过tr命令将用户输入的多个空格压缩为一个空格(去除重复的空格).
read -p "请输入:" input
input=`echo $input | tr -s ' '`

#判断用户输入的信息是否正确.
if grep -q "^$input$" $tmpfile ;then
    echo -e "\033[32m完全正确,恭喜!\033[0m"
else
    echo -e "\033[36mOops,再接再厉!\033[0m"
fi
rm -rf $tmpfile
