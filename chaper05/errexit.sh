#!/bin/bash
#功能描述(Description):通过set -e设置命令返回非0状态时脚本直接退出.

set -e
useradd root
echo "123456" | passwd --stdin root
echo "已经将root密码修改为:123456."
