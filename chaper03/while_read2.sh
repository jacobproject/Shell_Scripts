#!/bin/bash
#功能描述(Description):循环读取文件中的数据.
#通过IFS定义输入数据的分隔符(临时修改,仅对read有效).
#read定义7个变量,分别对应/etc/passwd每行数据中的7列.

while IFS=":" read user pass uid gid info home shell
do
    echo -e "My UID:$uid,\tMy home:$home"
done < /etc/passwd
