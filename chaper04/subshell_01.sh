#!/bin/bash
#描述(Description):子Shell演示示例.
#子Shell会继承父Shell的绝大多数环境,但父Shell无法读取子Shell的环境.

hi="hello"
echo "+++++++++++++++"
echo "+ 我是父Shell +"
echo "+++++++++++++++"
echo "PWD=$PWD."
echo "bash_subshll=$BASH_SUBSHELL."

#通过()开启子Shell.
(
sub_hi="I am a subshell"
echo -e "\t+++++++++++++++"
echo -e "\t+ 进入子Shell +"
echo -e "\t+++++++++++++++"
echo -e "\tPWD=$PWD."
echo -e "\tbash_subshll=$BASH_SUBSHELL."
echo -e "\thi=$hi."
echo -e "\tsub_hi=$sub_hi."
cd /etc;echo -e "\tPWD=$PWD"
)

echo  "+++++++++++++++"
echo  "+ 返回父Shell +"
echo  "+++++++++++++++"
echo "PWD=$PWD."
echo "hi=$hi."
echo "sub_hi=$sub_hi."
echo "bash_subshll=$BASH_SUBSHELL."
