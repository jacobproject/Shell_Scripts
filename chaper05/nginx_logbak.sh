#!/bin/bash
#功能描述(Description):使用脚本结合计划任务,定期对Nginx日志进行切割.

#本脚是按天为单位进行日志分割,如果需要按小时则需要更精确的时间标签.
datetime=$(date +%Y%m%d)
#假设日志目录为源码安装的标准目录,如果不是该目录则需要根据实际情况修改.
logpath=/usr/local/nginx/logs
mv $logpath/access.log $logpath/access-$datetime.log
mv $logpath/error.log  $logpath/error-$datetime.log

#脚本会读取标准日志目录下的nginx.pid文件,该文件中保存有nginx进程的进程号.
#如果该进程文件在其他目录,则需要根据实际情况进行适当修改.
kill -USR1 $(cat $logpath/nginx.pid)
