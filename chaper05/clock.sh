#!/bin/bash
#功能描述(Description):通过tput定位光标,在屏幕特定位置打印当前的计算机时间.

#使用Ctrl+C中断脚本时显示光标.
trap 'tput cnorm;exit' INT

#定义数组变量,该数组有9行9个元素,每行是1个元素,每一个数字宽度占用12列.
#循环对数组9个元素进行字串截取,每一个元素提取0-11位就是数字0,
#循环对数组9个元素进行字串截取,每一个元素提取12-23位就是数字1,依此类推.
number=(
'  0000000000      111     2222222222  3333333333 44    44     5555555555  6666666666   777777777   888888888  9999999999 '
'  00      00    11111             22          33 44    44     55          66           77     77   88     88  99      99 '
'  00      00   111111             22          33 44    44     55          66           77     77   88     88  99      99 '
'  00      00       11             22          33 44    44     55          66                  77   88     88  99      99 '
'  00      00       11     2222222222  3333333333 44444444444  5555555555  6666666666          77   888888888  9999999999 '
'  00      00       11     22                  33       44             55  66      66          77   88     88          99 '
'  00      00       11     22                  33       44             55  66      66          77   88     88          99 '
'  00      00       11     22                  33       44             55  66      66          77   88     88          99 '
'  0000000000  1111111111  2222222222  3333333333       44     5555555555  6666666666          77   888888888  9999999999 '
)

#获取计算机时间,并分别提取个位和十位数字.
now_time(){
hour=$(date +%H)
min=$(date +%M)
sec=$(date +%S)

hour_left=`echo $hour/10 | bc`
hour_right=`echo $hour%10 | bc`
min_left=`echo $min/10 | bc`
min_right=`echo $min%10 | bc`
sec_left=`echo $sec/10 | bc`
sec_right=`echo $sec%10 | bc`
}

#定义函数:打印数组中的某一个数字.
print_time(){
    #从第几个位置开始提取数组元素,数字0就从0开始,数字1就从12开始,数字2就从24开始,依此类推.
    begin=$[$1*12]
    for i in `seq 0 ${#number[@]}`   #0-9的循环.
    do
        tput cup $[i+5] $2           #定位光标
        echo -en "\033[32m${number[i]:$begin:12}\033[0m"
    done
}
#打印时间分隔符,echo通过\u可以支持unicode符号.
#unicode编码中2588是一个方块.
print_punct(){
    tput cup $1 $2
    echo -en "\e[32m\u2588\e[0m"
}
    
#依次打印小时,分钟,秒(个位和十位分别打印).
while :
do
    tput civis    #隐藏光标.
    now_time
    print_time $hour_left 2        #需要打印的数字以及X轴坐标(第几列).
    print_time $hour_right 14
    print_punct 8 28               #定义(Y,X)坐标位8,28,打印时间分隔符号.
    print_punct 10 28
    print_time $min_left 30
    print_time $min_right 42
    print_punct 8 56
    print_punct 10 56
    print_time $sec_left 58
    print_time $sec_right 70
    echo
    sleep 1
done

