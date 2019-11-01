#!/bin/bash
#功能描述(Description):生成随机临时文件.

#根据进程号生成随机文件.
touch /tmp/$$.tmp

#根据进程数量生成随机文件.
pnum=`ps aux | wc -l`
touch /tmp/$pnum.tmp

#根据文件个数生成随机文件.
fnum=`find /etc |wc -l`
touch /tmp/$fnum.tmp

#根据文件行数生成随机文件.
cnum=`cat /var/log/messages |wc -l`
touch /tmp/$cnum.tmp
