#!/bin/bash
#功能描述(Description):fork子进程的示例.

#调用外部命令时会导致fork子进程.
sleep 5

#绝对路径或相对路径调用外部脚本时会导致fork子进程.
/root/tmp.sh
cd /root; ./tmp.sh
