#!/bin/bash
#功能描述(Description):批量修改文件扩展名(对指定目录下的文件重命名).
#Author:http://manual.blog.51cto.com.

if [[ -z "$1" || -z "$2" || -z "$3" ]];then
    echo "Usage:$0  指定路径 旧扩展名 新扩展名."
    exit
fi

for i in `ls $1/*.$2`
do
    mv $i ${i%.$2}.$3
done
