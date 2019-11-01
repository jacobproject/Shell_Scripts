#!/bin/bash
#功能描述(Description):批量修改文件扩展名(对当前目录下的文件重命名).
#Author:http://manual.blog.51cto.com.

if [[ -z "$1" || -z "$2" ]];then
    echo "Usage:$0 旧扩展名 新扩展名."
    exit
fi

for i in `ls *.$1`
do
    mv $i ${i%.$1}.$2
done
