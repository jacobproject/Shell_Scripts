#!/bin/bash
#描述(Description):执行外部命令或加载其他脚本也会开启子Shell.

pstree
bash ./env.sh
echo "passwd=$password"
echo "Error:$error_info"

source ./env.sh
echo "passwd=$password"
echo "Error:$error_info"
