#!/bin/bash
#功能描述(Description):为拷贝文件设计一个进度条效果.

#防止提前执行Ctrl+C后无法结束进度条.
trap 'kill $!' INT

#定义变量,存储指针的四个符号.
rotate='|/-\'

#定义函数:实现动态指针进度条.
bar() {
#回车到下一行打印一个空格,第一次打印指针符号时会把这个空格删除.
#这里的空格主要目的是换行.
    printf ' '
    while :
    do
#删除前一个字符后,仅打印rotate变量中的第一个字符.
#没循环一次就将rotate中四个字符的位置调整一次.
        printf "\b%.1s" "$rotate"
        rotate=${rotate#?}${rotate%???}
        sleep 0.2
    done
}

bar &
cp -r $1 $2
kill $!
echo "拷贝结束!"
