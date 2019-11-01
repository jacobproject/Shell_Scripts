#!/bin/bash
#功能描述(Description):循环对多个文件进行备份操作.

for i in `ls /etc/*.conf`
do
    tar -czf /root/log/$(basename $i).tar.gz $i
done
