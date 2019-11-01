#!/bin/bash
#描述(Description):通过文件重定向读取文件解决Subshell问题.

tmp_file="/tmp/subshell-$$.txt"
df | grep "^/" > $tmp_file
while read name total used free other
do
    let sum+=free
done < $tmp_file
rm -rf $tmp_file
echo $sum
