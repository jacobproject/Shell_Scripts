#!/bin/bash
#功能描述(Description):演示shift命令的作用,左移位置参数.

echo "arg1=$1, arg2=$2, arg3=$3, arg4=$4, arg5=$5, arg6=$6, count=$#"
shift
echo "arg1=$1, arg2=$2, arg3=$3, arg4=$4, arg5=$5, arg6=$6, count=$#"
shift 2
echo "arg1=$1, arg2=$2, arg3=$3, arg4=$4, arg5=$5, arg6=$6, count=$#"
shift 1
echo "arg1=$1, arg2=$2, arg3=$3, arg4=$4, arg5=$5, arg6=$6, count=$#"
