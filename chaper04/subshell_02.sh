#!/bin/bash
#描述(Description):多级子Shell演示示例.
#子Shell会继承父Shell的绝大多数环境,但父Shell无法读取子Shell的环境.

hi="hello"
echo "+++++++++++++++"
echo "+ 我是父Shell +"
echo "+++++++++++++++"
echo "bash_subshll=$BASH_SUBSHELL."

#通过()开启子Shell.
(
echo -e "\t+++++++++++++++"
echo -e "\t+ 进入子Shell +"
echo -e "\t+++++++++++++++"
echo -e "\tbash_subshll=$BASH_SUBSHELL."
    (
    echo -e "\t\t+++++++++++++++"
    echo -e "\t\t+ 进入子Shell +"
    echo -e "\t\t+++++++++++++++"
    echo -e "\t\tbash_subshll=$BASH_SUBSHELL."
    pstree | grep subshell
    )
)

echo  "+++++++++++++++"
echo  "+ 返回父Shell +"
echo  "+++++++++++++++"
echo "bash_subshll=$BASH_SUBSHELL."
