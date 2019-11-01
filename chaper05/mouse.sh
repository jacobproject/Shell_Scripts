#!/bin/bash
#功能描述(Description):抓住随机出现的老鼠算你赢.

#使用Ctrl+C中断脚本时显示光标.
trap 'proc_exit' EXIT INT

#获取屏幕最大行和列数,定义游戏地图的大小为屏幕的1/4.
lines=`tput lines`
column=`tput cols`
left=2
right=$[column/2]
top=2
bottom=$[lines/2]

#定义函数,绘制一个长方形的游戏地图区域,使用#符号绘制游戏地图边界.
draw_map(){
    save_property=$(stty -g)                          #保存当前终端所有属性.
    tput clear
    tput civis                                        #关闭光标显示.
    echo -e "\033[1m\n\t按w(上),s(下),a(左),d(右),q(退出)键,控制笑脸抓住随机出现的小老鼠."
    for y in `seq  $top $bottom`                      #对地图的Y坐标(行号)循环.
    do
        local x=$left
        if [[ $y -eq $top || $y -eq $bottom ]];then   #判断Y坐标是否为顶部行或者底部行.
            while [ $x -le $right ]
            do
                tput cup $y $x
                echo -ne "\033[37;42m#\033[0m"        #Y坐标在left到right之间全部绘制#符号.
                let x++
            done
        else
            for m in $left $right                     #在Y坐标为left和right位置绘制两个#符号.
            do
                tput cup $y $m
                echo -ne "\033[37;42m#\033[0m"
            done
        fi
    done
    echo
}

#定义函数,对游戏地图区域内填充空格,以完成对地图的清屏操作,地图边界的#符号不清除.
clear_screen(){
    for((i=3;i<=$[bottom-1];i++))
    do
        space=""
        for((j=3;j<=$[right-1];j++))
        do
            space=${space}" "        #定义变量,值为right-3个空格.
        done
        tput cup $i 3                #使用空格覆盖清理游戏地图.
        echo -n "$space"
    done
}

#定义函数,在地图内部的指定坐标绘制一只小老鼠,Unicode编码中1F42D是老鼠形状.
draw_mouse(){
    tput cup $1 $2
    echo -en "\U1f42d"
}

#定义函数,在地图内部的指定坐标绘制一个笑脸,Unicode编码中1F642是笑脸形状.
draw_player(){
    tput cup $1 $2
    echo -en "\U1f642"
}

#定义函数,退出脚本时还原终端属性.
proc_exit(){
    tput cnorm
    stty $save_property
    echo "GameOver."
    exit
} 

#定义主函数,循环在屏幕显示笑脸和小老鼠,通过read读取用户输入,控制笑脸的移动.
get_key(){
    man_x=4     #笑脸的初始坐标X,Y=4,4
    man_y=4
    while :
    do
        tmp_col=$[right-2]
        tmp_line=$[bottom-1]
        rand_x=$[RANDOM%(tmp_col-left)+left+1]     #定义老鼠的随机坐标X.
        rand_y=$[RANDOM%(tmp_line-top)+top+1]      #定义老鼠的随机坐标Y.
        draw_player $man_y $man_x
        draw_mouse $rand_y $rand_x 
        #当笑脸和小老鼠坐标相同时,脚本退出.
        if [[ $man_x -eq $rand_x && $man_y -eq $rand_y ]];then
            proc_exit
        fi
        stty -echo                                #关闭输入的回显功能.
        #读取用户的输入,控制笑脸的新坐标.
        #如果笑脸坐标到达游戏地图的边缘则游戏结束.
        read -s -n 1 input
        if [[ $input == "q" || $input == "Q" ]];then
            proc_exit
        elif [[ $input == "w" || $input == "W" ]];then
            let man_y--
            [[ $man_y -le $top || $man_y -ge $bottom ]] && proc_exit  
            draw_player $man_y $man_x
        elif [[ $input == "s" || $input == "S" ]];then
            let man_y++
            [[ $man_y -le $top || $man_y -ge $bottom ]] && proc_exit
            draw_player $man_y $man_x
        elif [[ $input == "a" || $input == "A" ]];then
            let man_x--
            [[ $man_x -le $left || $man_x -ge $right ]] && proc_exit
            draw_player $man_y $man_x
        elif [[ $input == "d" || $input == "D" ]];then
            let man_x++
            [[ $man_x -le $left || $man_x -ge $right ]] && proc_exit
            draw_player $man_y $man_x
        fi
        clear_screen 
    done
}

draw_map
get_key
