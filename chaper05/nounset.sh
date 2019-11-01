#!/bin/bash
#功能描述(Description):通过设置nounset属性,防止变量未定义导致的意外错误.

set -u
useradd $1
echo "$2" | passwd --stdin $1
